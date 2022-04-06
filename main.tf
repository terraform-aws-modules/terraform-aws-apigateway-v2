# API Gateway
resource "aws_apigatewayv2_api" "this" {
  count = var.create && var.create_api_gateway ? 1 : 0

  name          = var.name
  description   = var.description
  protocol_type = var.protocol_type
  version       = var.api_version
  body          = var.body

  route_selection_expression   = var.route_selection_expression
  api_key_selection_expression = var.api_key_selection_expression
  disable_execute_api_endpoint = var.disable_execute_api_endpoint

  /* Start of quick create */
  route_key       = var.route_key
  credentials_arn = var.credentials_arn
  target          = var.target
  /* End of quick create */

  dynamic "cors_configuration" {
    for_each = length(keys(var.cors_configuration)) == 0 ? [] : [var.cors_configuration]

    content {
      allow_credentials = try(cors_configuration.value.allow_credentials, null)
      allow_headers     = try(cors_configuration.value.allow_headers, null)
      allow_methods     = try(cors_configuration.value.allow_methods, null)
      allow_origins     = try(cors_configuration.value.allow_origins, null)
      expose_headers    = try(cors_configuration.value.expose_headers, null)
      max_age           = try(cors_configuration.value.max_age, null)
    }
  }

  tags = var.tags
}

# Domain name
resource "aws_apigatewayv2_domain_name" "this" {
  count = var.create && var.create_api_domain_name ? 1 : 0

  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = var.domain_name_certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  dynamic "mutual_tls_authentication" {
    for_each = length(keys(var.mutual_tls_authentication)) == 0 ? [] : [var.mutual_tls_authentication]

    content {
      truststore_uri     = mutual_tls_authentication.value.truststore_uri
      truststore_version = try(mutual_tls_authentication.value.truststore_version, null)
    }
  }

  tags = merge(var.domain_name_tags, var.tags)
}

# Default stage
resource "aws_apigatewayv2_stage" "default" {
  count = var.create && var.create_default_stage ? 1 : 0

  api_id      = aws_apigatewayv2_api.this[0].id
  name        = "$default"
  auto_deploy = true

  dynamic "access_log_settings" {
    for_each = var.default_stage_access_log_destination_arn != null && var.default_stage_access_log_format != null ? [true] : []

    content {
      destination_arn = var.default_stage_access_log_destination_arn
      format          = var.default_stage_access_log_format
    }
  }

  dynamic "default_route_settings" {
    for_each = length(keys(var.default_route_settings)) == 0 ? [] : [var.default_route_settings]

    content {
      data_trace_enabled       = try(default_route_settings.value.data_trace_enabled, false)
      detailed_metrics_enabled = try(default_route_settings.value.detailed_metrics_enabled, false)
      logging_level            = try(default_route_settings.value.logging_level, null)
      throttling_burst_limit   = try(default_route_settings.value.throttling_burst_limit, null)
      throttling_rate_limit    = try(default_route_settings.value.throttling_rate_limit, null)
    }
  }

  #  # bug - https://github.com/terraform-providers/terraform-provider-aws/issues/12893
  #  dynamic "route_settings" {
  #    for_each = var.create_routes_and_integrations ? var.integrations : {}
  #    content {
  #      route_key = route_settings.key
  #      data_trace_enabled = try(route_settings.value.data_trace_enabled, null)
  #      detailed_metrics_enabled         = try(route_settings.value.detailed_metrics_enabled, null)
  #      logging_level         = try(route_settings.value.logging_level, null)  # Error: error updating API Gateway v2 stage ($default): BadRequestException: Execution logs are not supported on protocolType HTTP
  #      throttling_burst_limit         = try(route_settings.value.throttling_burst_limit, null)
  #      throttling_rate_limit         = try(route_settings.value.throttling_rate_limit, null)
  #    }
  #  }

  tags = merge(var.default_stage_tags, var.tags)

  # Bug in terraform-aws-provider with perpetual diff
  lifecycle {
    ignore_changes = [deployment_id]
  }
}

# Default API mapping
resource "aws_apigatewayv2_api_mapping" "this" {
  count = var.create && var.create_api_domain_name && var.create_default_stage && var.create_default_stage_api_mapping ? 1 : 0

  api_id      = aws_apigatewayv2_api.this[0].id
  domain_name = aws_apigatewayv2_domain_name.this[0].id
  stage       = aws_apigatewayv2_stage.default[0].id
}

# Routes and integrations
resource "aws_apigatewayv2_route" "this" {
  for_each = var.create && var.create_routes_and_integrations ? var.integrations : {}

  api_id    = aws_apigatewayv2_api.this[0].id
  route_key = each.key

  api_key_required                    = try(each.value.api_key_required, null)
  authorization_scopes                = try(split(",", each.value.authorization_scopes), null)
  authorization_type                  = try(each.value.authorization_type, "NONE")
  authorizer_id                       = try(aws_apigatewayv2_authorizer.this[each.value.authorizer_key].id, each.value.authorizer_id, null)
  model_selection_expression          = try(each.value.model_selection_expression, null)
  operation_name                      = try(each.value.operation_name, null)
  route_response_selection_expression = try(each.value.route_response_selection_expression, null)
  target                              = "integrations/${aws_apigatewayv2_integration.this[each.key].id}"

  # Have been added to the docs. But is WEBSOCKET only(not yet supported)
  # request_models  = try(each.value.request_models, null)
}

resource "aws_apigatewayv2_integration" "this" {
  for_each = var.create && var.create_routes_and_integrations ? var.integrations : {}

  api_id      = aws_apigatewayv2_api.this[0].id
  description = try(each.value.description, null)

  integration_type    = try(each.value.integration_type, try(each.value.lambda_arn, "") != "" ? "AWS_PROXY" : "MOCK")
  integration_subtype = try(each.value.integration_subtype, null)
  integration_method  = try(each.value.integration_method, try(each.value.integration_subtype, null) == null ? "POST" : null)
  integration_uri     = try(each.value.lambda_arn, try(each.value.integration_uri, null))

  connection_type = try(each.value.connection_type, "INTERNET")
  connection_id   = try(aws_apigatewayv2_vpc_link.this[each.value["vpc_link"]].id, try(each.value.connection_id, null))

  payload_format_version    = try(each.value.payload_format_version, null)
  timeout_milliseconds      = try(each.value.timeout_milliseconds, null)
  passthrough_behavior      = try(each.value.passthrough_behavior, null)
  content_handling_strategy = try(each.value.content_handling_strategy, null)
  credentials_arn           = try(each.value.credentials_arn, null)
  request_parameters        = try(jsondecode(each.value["request_parameters"]), each.value["request_parameters"], null)

  dynamic "tls_config" {
    for_each = flatten([try(jsondecode(each.value["tls_config"]), each.value["tls_config"], [])])

    content {
      server_name_to_verify = tls_config.value["server_name_to_verify"]
    }
  }

  dynamic "response_parameters" {
    for_each = flatten([try(jsondecode(each.value["response_parameters"]), each.value["response_parameters"], [])])

    content {
      status_code = response_parameters.value["status_code"]
      mappings    = response_parameters.value["mappings"]
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Authorizers
resource "aws_apigatewayv2_authorizer" "this" {
  for_each = var.create && var.create_routes_and_integrations ? var.authorizers : {}

  api_id = aws_apigatewayv2_api.this[0].id

  authorizer_type                   = try(each.value.authorizer_type, null)
  identity_sources                  = try(flatten([each.value.identity_sources]), null)
  name                              = try(each.value.name, null)
  authorizer_uri                    = try(each.value.authorizer_uri, null)
  authorizer_payload_format_version = try(each.value.authorizer_payload_format_version, null)
  authorizer_result_ttl_in_seconds  = try(each.value.authorizer_result_ttl_in_seconds, 300)

  dynamic "jwt_configuration" {
    for_each = length(try(each.value.audience, [each.value.issuer], [])) > 0 ? [true] : []

    content {
      audience = try(each.value.audience, null)
      issuer   = try(each.value.issuer, null)
    }
  }
}

# VPC Link (Private API)
resource "aws_apigatewayv2_vpc_link" "this" {
  for_each = var.create && var.create_vpc_link ? var.vpc_links : {}

  name               = try(each.value.name, each.key)
  security_group_ids = each.value["security_group_ids"]
  subnet_ids         = each.value["subnet_ids"]

  tags = merge(var.tags, var.vpc_link_tags, try(each.value.tags, {}))
}
