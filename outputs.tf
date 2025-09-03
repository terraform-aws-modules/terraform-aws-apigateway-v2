################################################################################
# API Gateway
################################################################################

output "api_id" {
  description = "The API identifier"
  value       = try(aws_apigatewayv2_api.this[0].id, null)
}

output "api_endpoint" {
  description = "URI of the API, of the form `https://{api-id}.execute-api.{region}.amazonaws.com` for HTTP APIs and `wss://{api-id}.execute-api.{region}.amazonaws.com` for WebSocket APIs"
  value       = try(aws_apigatewayv2_api.this[0].api_endpoint, null)
}

output "api_arn" {
  description = "The ARN of the API"
  value       = try(aws_apigatewayv2_api.this[0].arn, null)
}

output "api_execution_arn" {
  description = "The ARN prefix to be used in an `aws_lambda_permission`'s `source_arn` attribute or in an `aws_iam_policy` to authorize access to the `@connections` API"
  value       = try(aws_apigatewayv2_api.this[0].execution_arn, null)
}

################################################################################
# Authorizer(s)
################################################################################

output "authorizers" {
  description = "Map of API Gateway Authorizer(s) created and their attributes"
  value       = aws_apigatewayv2_authorizer.this
}

################################################################################
# Domain Name
################################################################################

output "domain_name_id" {
  description = "The domain name identifier"
  value       = try(aws_apigatewayv2_domain_name.this[0].id, null)
}

output "domain_name_arn" {
  description = "The ARN of the domain name"
  value       = try(aws_apigatewayv2_domain_name.this[0].arn, null)
}

output "domain_name_api_mapping_selection_expression" {
  description = "The API mapping selection expression for the domain name"
  value       = try(aws_apigatewayv2_domain_name.this[0].api_mapping_selection_expression, null)
}

output "domain_name_configuration" {
  description = "The domain name configuration"
  value       = try(aws_apigatewayv2_domain_name.this[0].domain_name_configuration, null)
}

output "domain_name_target_domain_name" {
  description = "The target domain name"
  value       = try(aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].target_domain_name, null)
}

output "domain_name_hosted_zone_id" {
  description = "The Amazon Route 53 Hosted Zone ID of the endpoint"
  value       = try(aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].hosted_zone_id, null)
}

################################################################################
# Domain - Certificate
################################################################################

output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = module.acm.acm_certificate_arn
}

################################################################################
# Integration(s)
################################################################################

output "integrations" {
  description = "Map of the integrations created and their attributes"
  value       = aws_apigatewayv2_integration.this
}

################################################################################
# Route(s)
################################################################################

output "routes" {
  description = "Map of the routes created and their attributes"
  value       = aws_apigatewayv2_route.this
}

################################################################################
# Stage
################################################################################

output "stage_id" {
  description = "The stage identifier"
  value       = try(aws_apigatewayv2_stage.this[0].id, null)
}

output "stage_domain_name" {
  description = "Domain name of the stage (useful for CloudFront distribution)"
  value       = replace(try(aws_apigatewayv2_stage.this[0].invoke_url, ""), "/^(wss?|https?)://([^/]*).*/", "$2")
}

output "stage_arn" {
  description = "The stage ARN"
  value       = try(aws_apigatewayv2_stage.this[0].arn, null)
}

output "stage_execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API"
  value       = try(aws_apigatewayv2_stage.this[0].execution_arn, null)
}

output "stage_invoke_url" {
  description = "The URL to invoke the API pointing to the stage"
  value       = try(aws_apigatewayv2_stage.this[0].invoke_url, null)
}

################################################################################
# Stage Access Logs - Log Group
################################################################################

output "stage_access_logs_cloudwatch_log_group_name" {
  description = "Name of cloudwatch log group created"
  value       = try(aws_cloudwatch_log_group.this["this"].name, null)
}

output "stage_access_logs_cloudwatch_log_group_arn" {
  description = "Arn of cloudwatch log group created"
  value       = try(aws_cloudwatch_log_group.this["this"].arn, null)
}

################################################################################
# VPC Link
################################################################################

output "vpc_links" {
  description = "Map of VPC links created and their attributes"
  value       = aws_apigatewayv2_vpc_link.this
}
