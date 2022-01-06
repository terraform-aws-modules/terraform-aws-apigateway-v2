################################################################################
# API Gateway
################################################################################

output "api_id" {
  description = "The API identifier"
  value       = try(aws_apigatewayv2_api.this[0].id, "")
}

output "api_endpoint" {
  description = "The URI of the API"
  value       = try(aws_apigatewayv2_api.this[0].api_endpoint, "")
}

output "api_arn" {
  description = "The ARN of the API"
  value       = try(aws_apigatewayv2_api.this[0].arn, "")
}

output "api_execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API."
  value       = try(aws_apigatewayv2_api.this[0].execution_arn, "")
}

output "api_mapping_id" {
  description = "The API mapping identifier"
  value       = try(aws_apigatewayv2_api_mapping.this[0].id, "")
}

################################################################################
# Domain Name
################################################################################

output "domain_name_id" {
  description = "The domain name identifier"
  value       = try(aws_apigatewayv2_domain_name.this[0].id, "")
}

output "domain_name_arn" {
  description = "The ARN of the domain name"
  value       = try(aws_apigatewayv2_domain_name.this[0].arn, "")
}

output "domain_name_api_mapping_selection_expression" {
  description = "The API mapping selection expression for the domain name"
  value       = try(aws_apigatewayv2_domain_name.this[0].api_mapping_selection_expression, "")
}

output "domain_name_configuration" {
  description = "The domain name configuration"
  value       = try(aws_apigatewayv2_domain_name.this[0].domain_name_configuration, "")
}

output "domain_name_target_domain_name" {
  description = "The target domain name"
  value       = try(aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].target_domain_name, "")
}

output "domain_name_hosted_zone_id" {
  description = "The Amazon Route 53 Hosted Zone ID of the endpoint"
  value       = try(aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].hosted_zone_id, "")
}

################################################################################
# API Gateway Stage
################################################################################

output "stage_id" {
  description = "The stage identifier"
  value       = try(aws_apigatewayv2_stage.this[0].id, "")
}

output "stage_arn" {
  description = "The stage ARN"
  value       = try(aws_apigatewayv2_stage.this[0].arn, "")
}

output "stage_execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API."
  value       = try(aws_apigatewayv2_stage.this[0].execution_arn, "")
}

output "stage_invoke_url" {
  description = "The URL to invoke the API pointing to the stage"
  value       = try(aws_apigatewayv2_stage.this[0].invoke_url, "")
}

################################################################################
# Route(s)
################################################################################

output "routes" {
  description = "Map of the routes created and their attributes"
  value       = aws_apigatewayv2_route.this
}

################################################################################
# Integration(s)
################################################################################

output "integrations" {
  description = "Map of the integrations created and their attributes"
  value       = aws_apigatewayv2_integration.this
}

################################################################################
# VPC Link
################################################################################

output "vpc_links" {
  description = "Map of VPC links created and their attributes"
  value       = aws_apigatewayv2_vpc_link.this
}
