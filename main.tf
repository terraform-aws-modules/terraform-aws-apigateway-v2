locals {
  is_http      = var.protocol_type == "HTTP"
  is_websocket = var.protocol_type == "WEBSOCKET"

  create_routes_and_integrations = var.create && var.create_routes_and_integrations
}

################################################################################
# API Gateway
################################################################################

resource "aws_apigatewayv2_api" "this" {
  count = var.create ? 1 : 0

  api_key_selection_expression = local.is_websocket ? var.api_key_selection_expression : null
  body                         = local.is_http ? var.body : null

  dynamic "cors_configuration" {
    for_each = local.is_http && length(var.cors_configuration) > 0 ? [var.cors_configuration] : []

    content {
      allow_credentials = try(cors_configuration.value.allow_credentials, null)
      allow_headers     = try(cors_configuration.value.allow_headers, null)
      allow_methods     = try(cors_configuration.value.allow_methods, null)
      allow_origins     = try(cors_configuration.value.allow_origins, null)
      expose_headers    = try(cors_configuration.value.expose_headers, null)
      max_age           = try(cors_configuration.value.max_age, null)
    }
  }

  credentials_arn = local.is_http ? var.credentials_arn : null
  description     = var.description
  # https://docs.aws.amazon.com/apigateway/latest/developerguide/rest-api-disable-default-endpoint.html
  disable_execute_api_endpoint = local.is_http && local.create_domain_name ? true : var.disable_execute_api_endpoint
  fail_on_warnings             = local.is_http ? var.fail_on_warnings : null
  name                         = var.name
  protocol_type                = var.protocol_type
  route_key                    = local.is_http ? var.route_key : null
  route_selection_expression   = var.route_selection_expression
  target                       = local.is_http ? var.target : null
  version                      = var.api_version

  tags = var.tags
}

################################################################################
# Authorizer(s)
################################################################################

resource "aws_apigatewayv2_authorizer" "this" {
  for_each = { for k, v in var.authorizers : k => v if local.create_routes_and_integrations }

  api_id = aws_apigatewayv2_api.this[0].id

  authorizer_credentials_arn        = try(each.value.authorizer_credentials_arn, null)
  authorizer_payload_format_version = try(each.value.authorizer_payload_format_version, null)
  authorizer_result_ttl_in_seconds  = try(each.value.authorizer_result_ttl_in_seconds, null)
  authorizer_type                   = try(each.value.authorizer_type, null)
  authorizer_uri                    = try(each.value.authorizer_uri, null)
  enable_simple_responses           = try(each.value.enable_simple_responses, null)
  identity_sources                  = try(flatten([each.value.identity_sources]), null)

  dynamic "jwt_configuration" {
    for_each = try([each.value.jwt_configuration], [])

    content {
      audience = try(jwt_configuration.value.audience, null)
      issuer   = try(jwt_configuration.value.issuer, null)
    }
  }

  name = try(each.value.name, each.key)
}

################################################################################
# Domain Name
################################################################################

locals {
  create_domain_name = var.create && var.create_domain_name
}

resource "aws_apigatewayv2_domain_name" "this" {
  count = local.create_domain_name ? 1 : 0

  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn                        = local.create_certificate ? module.acm.acm_certificate_arn : var.domain_name_certificate_arn
    endpoint_type                          = "REGIONAL"
    security_policy                        = "TLS_1_2"
    ownership_verification_certificate_arn = var.domain_name_ownership_verification_certificate_arn
  }

  dynamic "mutual_tls_authentication" {
    for_each = length(var.mutual_tls_authentication) > 0 ? [var.mutual_tls_authentication] : []

    content {
      truststore_uri     = mutual_tls_authentication.value.truststore_uri
      truststore_version = try(mutual_tls_authentication.value.truststore_version, null)
    }
  }

  tags = var.tags
}

resource "aws_apigatewayv2_api_mapping" "this" {
  count = local.create_domain_name && local.create_stage ? 1 : 0

  api_id          = aws_apigatewayv2_api.this[0].id
  api_mapping_key = var.api_mapping_key
  domain_name     = aws_apigatewayv2_domain_name.this[0].id
  stage           = aws_apigatewayv2_stage.this[0].id
}

################################################################################
# Domain - Route53 Record
################################################################################

locals {
  # https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-custom-domains.html
  stripped_domain_name = replace(var.domain_name, "*.", "")
}

data "aws_route53_zone" "this" {
  count = local.create_domain_name && var.create_domain_records ? 1 : 0

  name = local.stripped_domain_name
}

resource "aws_route53_record" "alias_ipv4" {
  for_each = { for k, v in toset(var.subdomains) : k => v if local.create_domain_name && var.create_domain_records }

  zone_id = data.aws_route53_zone.this[0].zone_id
  name    = each.value
  type    = "A"

  alias {
    name                   = aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

################################################################################
# Domain - Certificate
################################################################################

locals {
  create_certificate = local.create_domain_name && var.create_certificate

  is_wildcard = startswith(var.domain_name, "*.")
}

module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "5.0.1"

  create_certificate = local.create_certificate

  domain_name               = local.stripped_domain_name
  zone_id                   = data.aws_route53_zone.this[0].id
  subject_alternative_names = local.is_wildcard ? [var.domain_name] : [for sub in var.subdomains : "${sub}.${local.stripped_domain_name}"]

  validation_method = "DNS"

  tags = var.tags
}

################################################################################
# Integration(s)
################################################################################

resource "aws_apigatewayv2_integration" "this" {
  for_each = { for k, v in var.integrations : k => v if local.create_routes_and_integrations }

  api_id = aws_apigatewayv2_api.this[0].id

  connection_id             = try(aws_apigatewayv2_vpc_link.this[each.value.vpc_link].id, lookup(each.value, "connection_id", null))
  connection_type           = try(each.value.connection_type, null)
  content_handling_strategy = try(each.value.content_handling_strategy, null)
  credentials_arn           = try(each.value.credentials_arn, null)
  description               = try(each.value.description, null)
  integration_method        = try(each.value.integration_method, try(each.value.integration_subtype, null) == null ? "POST" : null)
  integration_subtype       = try(each.value.integration_subtype, null)
  integration_type          = try(each.value.integration_type, try(each.value.lambda_arn, "") != "" ? "AWS_PROXY" : "MOCK")
  integration_uri           = try(each.value.lambda_arn, try(each.value.integration_uri, null))
  passthrough_behavior      = try(each.value.passthrough_behavior, null)
  payload_format_version    = try(each.value.payload_format_version, null)
  request_parameters        = try(each.value.request_parameters, null)
  request_templates         = try(each.value.request_templates, null)

  dynamic "response_parameters" {
    for_each = try(each.value.response_parameters, [])

    content {
      mappings    = response_parameters.value.mappings
      status_code = response_parameters.value.status_code
    }
  }

  template_selection_expression = try(each.value.template_selection_expression, null)
  timeout_milliseconds          = try(each.value.timeout_milliseconds, null)

  dynamic "tls_config" {
    for_each = try([each.value.tls_config], [])

    content {
      server_name_to_verify = replace(tls_config.value.server_name_to_verify, "*.", "")
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

################################################################################
# Integration(s) Response
################################################################################

resource "aws_apigatewayv2_integration_response" "this" {
  for_each = { for k, v in var.integrations : k => v if local.create_routes_and_integrations && try(v.integration_response_key, null) != null }

  api_id         = aws_apigatewayv2_api.this[0].id
  integration_id = aws_apigatewayv2_integration.this[each.key].id

  content_handling_strategy     = try(each.value.content_handling_strategy, null)
  integration_response_key      = each.value.integration_response_key
  response_templates            = try(each.value.response_templates, null)
  template_selection_expression = try(each.value.template_selection_expression, null)
}

################################################################################
# Route(s)
################################################################################

resource "aws_apigatewayv2_route" "this" {
  for_each = { for k, v in var.integrations : k => v if local.create_routes_and_integrations }

  api_id = aws_apigatewayv2_api.this[0].id

  api_key_required           = local.is_websocket ? try(each.value.api_key_required, null) : null
  authorization_scopes       = try(each.value.authorization_scopes, null)
  authorization_type         = try(each.value.authorization_type, null)
  authorizer_id              = try(aws_apigatewayv2_authorizer.this[each.value.authorizer_key].id, each.value.authorizer_id, null)
  model_selection_expression = local.is_websocket ? try(each.value.model_selection_expression, null) : null
  operation_name             = try(each.value.operation_name, null)
  request_models             = local.is_websocket ? try(each.value.request_models, {}) : null

  dynamic "request_parameter" {
    for_each = local.is_websocket ? try(each.value.request_parameter, []) : []

    content {
      request_parameter_key = request_parameter.value.request_parameter_key
      required              = request_parameter.value.required
    }
  }

  route_key                           = each.key
  route_response_selection_expression = local.is_websocket ? try(each.value.route_response_selection_expression, null) : null
  target                              = "integrations/${aws_apigatewayv2_integration.this[each.key].id}"
}

################################################################################
# Stage
################################################################################

locals {
  create_stage = var.create && var.create_stage
}

resource "aws_apigatewayv2_stage" "this" {
  count = local.create_stage ? 1 : 0

  api_id = aws_apigatewayv2_api.this[0].id

  dynamic "access_log_settings" {
    for_each = length(var.stage_access_log_settings) > 0 ? [var.stage_access_log_settings] : []

    content {
      destination_arn = try(access_log_settings.value.create_log_group, true) ? aws_cloudwatch_log_group.this["default"].arn : access_log_settings.value.destination_arn
      format          = access_log_settings.value.format
    }
  }

  auto_deploy           = local.is_http ? true : null
  client_certificate_id = local.is_websocket ? var.stage_client_certificate_id : null

  dynamic "default_route_settings" {
    for_each = length(var.stage_default_route_settings) > 0 ? [var.stage_default_route_settings] : []

    content {
      data_trace_enabled       = local.is_websocket ? try(default_route_settings.value.data_trace_enabled, false) : null
      detailed_metrics_enabled = try(default_route_settings.value.detailed_metrics_enabled, false)
      logging_level            = local.is_websocket ? try(default_route_settings.value.logging_level, null) : null
      throttling_burst_limit   = try(default_route_settings.value.throttling_burst_limit, 500)
      throttling_rate_limit    = try(default_route_settings.value.throttling_rate_limit, 1000)
    }
  }

  description = var.stage_description
  name        = var.stage_name

  dynamic "route_settings" {
    for_each = { for k, v in var.integrations : k => v if var.create_routes_and_integrations }

    content {
      data_trace_enabled       = local.is_websocket ? try(route_settings.value.data_trace_enabled, false) : null
      detailed_metrics_enabled = try(route_settings.value.detailed_metrics_enabled, false)
      logging_level            = local.is_websocket ? try(route_settings.value.logging_level, null) : null
      route_key                = route_settings.key
      throttling_burst_limit   = try(route_settings.value.throttling_burst_limit, 500)
      throttling_rate_limit    = try(route_settings.value.throttling_rate_limit, 1000)
    }
  }

  stage_variables = var.stage_variables

  tags = merge(var.tags, var.stage_tags)

  depends_on = [
    aws_apigatewayv2_route.this
  ]
}

################################################################################
# Stage Access Logs - Log Group
################################################################################

resource "aws_cloudwatch_log_group" "this" {
  for_each = { for k, v in { "default" = var.stage_access_log_settings } : k => v if local.create_stage && try(v.create_log_group, true) }

  name              = try(each.value.log_group_name, "/aws/api-gateway/${var.name}/${replace(var.stage_name, "$", "")}")
  retention_in_days = try(each.value.log_group_retention_in_days, 30)
  kms_key_id        = try(each.value.log_group_kms_key_id, null)
  skip_destroy      = try(each.value.log_group_skip_destroy, null)
  log_group_class   = try(each.value.log_group_class, null)

  tags = merge(var.tags, try(each.value.tags, {}))
}

################################################################################
# VPC Link
################################################################################

resource "aws_apigatewayv2_vpc_link" "this" {
  for_each = { for k, v in var.vpc_links : k => v if var.create }

  name               = try(each.value.name, each.key)
  security_group_ids = each.value.security_group_ids
  subnet_ids         = each.value.subnet_ids

  tags = merge(var.tags, var.vpc_link_tags, try(each.value.tags, {}))
}
