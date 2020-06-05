# API Gateway
resource "aws_apigatewayv2_api" "this" {
  count = var.create && var.create_api_gateway ? 1 : 0

  name          = var.name
  description   = var.description
  protocol_type = var.protocol_type
  version       = var.api_version

  route_selection_expression   = var.route_selection_expression
  api_key_selection_expression = var.api_key_selection_expression

  /* Start of quick create */
  route_key       = var.route_key
  credentials_arn = var.credentials_arn
  target          = var.target
  /* End of quick create */

  dynamic "cors_configuration" {
    for_each = length(keys(var.cors_configuration)) == 0 ? [] : [var.cors_configuration]

    content {
      allow_credentials = lookup(cors_configuration.value, "allow_credentials", null)
      allow_headers     = lookup(cors_configuration.value, "allow_headers", null)
      allow_methods     = lookup(cors_configuration.value, "allow_methods", null)
      allow_origins     = lookup(cors_configuration.value, "allow_origins", null)
      expose_headers    = lookup(cors_configuration.value, "expose_headers", null)
      max_age           = lookup(cors_configuration.value, "max_age", null)
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

  tags = merge(var.domain_name_tags, var.tags)
}

# Default stage
resource "aws_apigatewayv2_stage" "default" {
  count = var.create && var.create_default_stage ? 1 : 0

  api_id      = aws_apigatewayv2_api.this[0].id
  name        = "$default"
  auto_deploy = true

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
  target    = "integrations/${aws_apigatewayv2_integration.this[each.key].id}"
}

resource "aws_apigatewayv2_integration" "this" {
  for_each = var.create && var.create_routes_and_integrations ? var.integrations : {}

  api_id           = aws_apigatewayv2_api.this[0].id
  integration_type = lookup(each.value, "integration_type", lookup(each.value, "lambda_arn", "") != "" ? "AWS_PROXY" : "MOCK")
  description      = lookup(each.value, "description", null)

  connection_type    = lookup(each.value, "connection_type", "INTERNET")
  integration_method = lookup(each.value, "integration_method", "ANY") # Q: Where this is used in API gateway? I can't see it in UI.
  integration_uri    = lookup(each.value, "lambda_arn", null)

  payload_format_version = lookup(each.value, "payload_format_version", null)
  timeout_milliseconds   = lookup(each.value, "timeout_milliseconds", null)

  # Due to open issue - https://github.com/terraform-providers/terraform-provider-aws/issues/11148#issuecomment-619160589
  # Bug in terraform-aws-provider with perpetual diff
  lifecycle {
    ignore_changes = [passthrough_behavior]
  }
}
