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
    for_each = local.is_http && var.cors_configuration != null ? [var.cors_configuration] : []

    content {
      allow_credentials = cors_configuration.value.allow_credentials
      allow_headers     = cors_configuration.value.allow_headers
      allow_methods     = cors_configuration.value.allow_methods
      allow_origins     = cors_configuration.value.allow_origins
      expose_headers    = cors_configuration.value.expose_headers
      max_age           = cors_configuration.value.max_age
    }
  }

  credentials_arn = local.is_http ? var.credentials_arn : null
  description     = var.description
  # https://docs.aws.amazon.com/apigateway/latest/developerguide/rest-api-disable-default-endpoint.html
  disable_execute_api_endpoint = local.is_http && local.create_domain_name ? true : var.disable_execute_api_endpoint
  fail_on_warnings             = local.is_http ? var.fail_on_warnings : null
  ip_address_type              = var.ip_address_type
  name                         = var.name
  protocol_type                = var.protocol_type
  route_key                    = local.is_http ? var.route_key : null
  route_selection_expression   = var.route_selection_expression
  target                       = local.is_http ? var.target : null
  version                      = var.api_version

  tags = merge(
    { terraform-aws-modules = "apigateway-v2" },
    var.tags,
  )
}

################################################################################
# Authorizer(s)
################################################################################

resource "aws_apigatewayv2_authorizer" "this" {
  for_each = { for k, v in var.authorizers : k => v if var.create }

  api_id = aws_apigatewayv2_api.this[0].id

  authorizer_credentials_arn        = each.value.authorizer_credentials_arn
  authorizer_payload_format_version = each.value.authorizer_payload_format_version
  authorizer_result_ttl_in_seconds  = each.value.authorizer_result_ttl_in_seconds
  authorizer_type                   = each.value.authorizer_type
  authorizer_uri                    = each.value.authorizer_uri
  enable_simple_responses           = each.value.enable_simple_responses
  identity_sources                  = each.value.identity_sources

  dynamic "jwt_configuration" {
    for_each = each.value.jwt_configuration != null ? [each.value.jwt_configuration] : []

    content {
      audience = jwt_configuration.value.audience
      issuer   = jwt_configuration.value.issuer
    }
  }

  name = coalesce(each.value.name, each.key)
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
    ip_address_type                        = var.ip_address_type
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

  record_names = coalescelist(var.subdomains, [local.stripped_domain_name])
  record_set = { for prd in setproduct(local.record_names, var.subdomain_record_types) : "${prd[0]}-${prd[1]}" => {
    name = prd[0]
    type = prd[1]
  } }
}

data "aws_route53_zone" "this" {
  count = local.create_domain_name && var.create_domain_records ? 1 : 0

  name = coalesce(var.hosted_zone_name, local.stripped_domain_name)
}

resource "aws_route53_record" "this" {
  for_each = { for k, v in local.record_set : k => v if local.create_domain_name && var.create_domain_records }

  zone_id = data.aws_route53_zone.this[0].zone_id
  name    = each.value.name
  type    = each.value.type

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

  create_certificate = local.create_domain_name && var.create_domain_records && local.create_certificate

  domain_name               = local.stripped_domain_name
  zone_id                   = try(data.aws_route53_zone.this[0].id, "")
  subject_alternative_names = local.is_wildcard ? [var.domain_name] : [for sub in var.subdomains : "${sub}.${local.stripped_domain_name}"]

  validation_method = "DNS"

  tags = var.tags
}

################################################################################
# Route(s)
################################################################################

resource "aws_apigatewayv2_route" "this" {
  for_each = { for k, v in var.routes : k => v if local.create_routes_and_integrations }

  api_id = aws_apigatewayv2_api.this[0].id

  api_key_required           = local.is_websocket ? each.value.api_key_required : null
  authorization_scopes       = each.value.authorization_scopes
  authorization_type         = each.value.authorization_type
  authorizer_id              = try(aws_apigatewayv2_authorizer.this[each.value.authorizer_key].id, each.value.authorizer_id)
  model_selection_expression = local.is_websocket ? each.value.model_selection_expression : null
  operation_name             = each.value.operation_name
  request_models             = local.is_websocket ? each.value.request_models : null

  dynamic "request_parameter" {
    for_each = { for k, v in each.value.request_parameter : k => v if try(v.request_parameter_key, null) != null && local.is_websocket }

    content {
      request_parameter_key = request_parameter.value.request_parameter_key
      required              = request_parameter.value.required
    }
  }

  route_key                           = each.key
  route_response_selection_expression = local.is_websocket ? each.value.route_response_selection_expression : null
  target                              = "integrations/${aws_apigatewayv2_integration.this[each.key].id}"
}

################################################################################
# Route Response(s)
################################################################################

resource "aws_apigatewayv2_route_response" "this" {
  for_each = { for k, v in var.routes : k => v if local.create_routes_and_integrations && coalesce(v.route_response.create, false) }

  api_id                     = aws_apigatewayv2_api.this[0].id
  model_selection_expression = each.value.route_response.model_selection_expression
  response_models            = each.value.route_response.response_models
  route_id                   = aws_apigatewayv2_route.this[each.key].id
  route_response_key         = each.value.route_response.route_response_key
}

################################################################################
# Integration(s)
################################################################################

resource "aws_apigatewayv2_integration" "this" {
  for_each = { for k, v in var.routes : k => v.integration if local.create_routes_and_integrations }

  api_id = aws_apigatewayv2_api.this[0].id

  connection_id             = try(aws_apigatewayv2_vpc_link.this[each.value.vpc_link_key].id, each.value.connection_id)
  connection_type           = each.value.connection_type
  content_handling_strategy = each.value.content_handling_strategy
  credentials_arn           = each.value.credentials_arn
  description               = each.value.description
  integration_method        = each.value.method
  integration_subtype       = each.value.subtype
  integration_type          = each.value.type
  integration_uri           = each.value.uri
  passthrough_behavior      = each.value.passthrough_behavior
  payload_format_version    = each.value.payload_format_version
  request_parameters        = each.value.request_parameters
  request_templates         = each.value.request_templates

  dynamic "response_parameters" {
    for_each = coalesce(each.value.response_parameters, [])

    content {
      mappings    = response_parameters.value.mappings
      status_code = response_parameters.value.status_code
    }
  }

  template_selection_expression = each.value.template_selection_expression
  timeout_milliseconds          = each.value.timeout_milliseconds

  dynamic "tls_config" {
    for_each = each.value.tls_config != null && !local.is_websocket ? [each.value.tls_config] : []

    content {
      server_name_to_verify = try(tls_config.value.server_name_to_verify, null)
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
  for_each = { for k, v in var.routes : k => v.integration if local.create_routes_and_integrations && v.integration.response.integration_response_key != null }

  api_id         = aws_apigatewayv2_api.this[0].id
  integration_id = aws_apigatewayv2_integration.this[each.key].id

  content_handling_strategy     = each.value.response.content_handling_strategy
  integration_response_key      = each.value.response.integration_response_key
  response_templates            = each.value.response.response_templates
  template_selection_expression = each.value.response.template_selection_expression
}

################################################################################
# Stage
################################################################################

locals {
  create_stage = var.create && var.create_stage

  default_log_format = jsonencode({
    context = {
      domainName              = "$context.domainName"
      integrationErrorMessage = "$context.integrationErrorMessage"
      protocol                = "$context.protocol"
      requestId               = "$context.requestId"
      requestTime             = "$context.requestTime"
      responseLength          = "$context.responseLength"
      routeKey                = "$context.routeKey"
      stage                   = "$context.stage"
      status                  = "$context.status"
      error = {
        message      = "$context.error.message"
        responseType = "$context.error.responseType"
      }
      identity = {
        sourceIP = "$context.identity.sourceIp"
      }
      integration = {
        error             = "$context.integration.error"
        integrationStatus = "$context.integration.integrationStatus"
      }
    }
  })
}

resource "aws_apigatewayv2_stage" "this" {
  count = local.create_stage ? 1 : 0

  api_id = aws_apigatewayv2_api.this[0].id

  dynamic "access_log_settings" {
    for_each = var.stage_access_log_settings != null ? [var.stage_access_log_settings] : []

    content {
      destination_arn = access_log_settings.value.create_log_group ? aws_cloudwatch_log_group.this["this"].arn : access_log_settings.value.destination_arn
      format          = coalesce(access_log_settings.value.format, local.default_log_format)
    }
  }

  auto_deploy           = local.is_http ? true : null
  client_certificate_id = local.is_websocket ? var.stage_client_certificate_id : null

  dynamic "default_route_settings" {
    for_each = var.stage_default_route_settings != null ? [var.stage_default_route_settings] : []

    content {
      data_trace_enabled       = local.is_websocket ? default_route_settings.value.data_trace_enabled : null
      detailed_metrics_enabled = default_route_settings.value.detailed_metrics_enabled
      logging_level            = local.is_websocket ? default_route_settings.value.logging_level : null
      throttling_burst_limit   = default_route_settings.value.throttling_burst_limit
      throttling_rate_limit    = default_route_settings.value.throttling_rate_limit
    }
  }

  deployment_id = local.is_http ? null : try(aws_apigatewayv2_deployment.this[0].id, null)
  description   = var.stage_description
  name          = var.stage_name

  dynamic "route_settings" {
    for_each = { for k, v in var.routes : k => v if var.create_routes_and_integrations }

    content {
      data_trace_enabled       = local.is_websocket ? coalesce(route_settings.value.data_trace_enabled, var.stage_default_route_settings.data_trace_enabled) : null
      detailed_metrics_enabled = coalesce(route_settings.value.detailed_metrics_enabled, var.stage_default_route_settings.detailed_metrics_enabled)
      logging_level            = local.is_websocket ? coalesce(route_settings.value.logging_level, var.stage_default_route_settings.logging_level) : null
      route_key                = route_settings.key
      throttling_burst_limit   = coalesce(route_settings.value.throttling_burst_limit, var.stage_default_route_settings.throttling_burst_limit)
      throttling_rate_limit    = coalesce(route_settings.value.throttling_rate_limit, var.stage_default_route_settings.throttling_rate_limit)
    }
  }

  stage_variables = var.stage_variables

  tags = merge(var.tags, var.stage_tags)

  depends_on = [
    aws_apigatewayv2_route.this
  ]
}

################################################################################
# Deployment
################################################################################

resource "aws_apigatewayv2_deployment" "this" {
  count = local.create_stage && var.deploy_stage && !local.is_http ? 1 : 0

  api_id      = aws_apigatewayv2_api.this[0].id
  description = var.description

  triggers = {
    redeployment = sha1(join(",", tolist([
      jsonencode(aws_apigatewayv2_integration.this),
      jsonencode(aws_apigatewayv2_route.this),
      jsonencode(aws_apigatewayv2_route_response.this),
      jsonencode(aws_apigatewayv2_api.this[0].body),
      jsonencode(aws_apigatewayv2_authorizer.this),
    ])))
  }

  depends_on = [
    aws_apigatewayv2_api.this,
    aws_apigatewayv2_route.this,
    aws_apigatewayv2_integration.this,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

################################################################################
# Stage Access Logs - Log Group
################################################################################

resource "aws_cloudwatch_log_group" "this" {
  for_each = { for k, v in { "this" = var.stage_access_log_settings } : k => v if local.create_stage && v != null && try(v.create_log_group, true) }

  name              = coalesce(each.value.log_group_name, "/aws/apigateway/${var.name}/${replace(var.stage_name, "$", "")}")
  retention_in_days = each.value.log_group_retention_in_days
  kms_key_id        = each.value.log_group_kms_key_id
  skip_destroy      = each.value.log_group_skip_destroy
  log_group_class   = each.value.log_group_class

  tags = merge(var.tags, each.value.log_group_tags)
}

################################################################################
# VPC Link
################################################################################

resource "aws_apigatewayv2_vpc_link" "this" {
  for_each = { for k, v in var.vpc_links : k => v if var.create }

  name               = coalesce(each.value.name, each.key)
  security_group_ids = each.value.security_group_ids
  subnet_ids         = each.value.subnet_ids

  tags = merge(var.tags, var.vpc_link_tags, try(each.value.tags, {}))
}
