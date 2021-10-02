output "apigatewayv2_api_id" {
  description = "The API identifier"
  value       = module.api_gateway.apigatewayv2_api_id
}

output "apigatewayv2_api_api_endpoint" {
  description = "The URI of the API"
  value       = module.api_gateway.apigatewayv2_api_api_endpoint
}

output "apigatewayv2_api_arn" {
  description = "The ARN of the API"
  value       = module.api_gateway.apigatewayv2_api_arn
}

output "apigatewayv2_api_execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API."
  value       = module.api_gateway.apigatewayv2_api_execution_arn
}

# stage
output "apigatewayv2_stage_id" {
  description = "The default stage identifier"
  value       = module.api_gateway.apigatewayv2_stage_id
}

output "apigatewayv2_stage_arn" {
  description = "The default stage ARN"
  value       = module.api_gateway.apigatewayv2_stage_arn
}

output "apigatewayv2_stage_execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API."
  value       = module.api_gateway.apigatewayv2_stage_execution_arn
}

output "apigatewayv2_stage_invoke_url" {
  description = "The URL to invoke the API pointing to the stage"
  value       = module.api_gateway.apigatewayv2_stage_invoke_url
}

output "apigatewayv2_stage_domain_name" {
  description = "Domain name of the stage (useful for CloudFront distribution)"
  value       = module.api_gateway.apigatewayv2_stage_domain_name
}

# domain name
output "apigatewayv2_domain_name_id" {
  description = "The domain name identifier"
  value       = module.api_gateway.apigatewayv2_domain_name_id
}

output "apigatewayv2_domain_name_arn" {
  description = "The ARN of the domain name"
  value       = module.api_gateway.apigatewayv2_domain_name_arn
}

output "apigatewayv2_domain_name_api_mapping_selection_expression" {
  description = "The API mapping selection expression for the domain name"
  value       = module.api_gateway.apigatewayv2_domain_name_api_mapping_selection_expression
}

output "apigatewayv2_domain_name_configuration" {
  description = "The domain name configuration"
  value       = module.api_gateway.apigatewayv2_domain_name_configuration
}

output "apigatewayv2_domain_name_target_domain_name" {
  description = "The target domain name"
  value       = module.api_gateway.apigatewayv2_domain_name_target_domain_name
}

output "apigatewayv2_domain_name_hosted_zone_id" {
  description = "The Amazon Route 53 Hosted Zone ID of the endpoint"
  value       = module.api_gateway.apigatewayv2_domain_name_hosted_zone_id
}

# api mapping
output "apigatewayv2_api_mapping_id" {
  description = "The API mapping identifier"
  value       = module.api_gateway.apigatewayv2_api_mapping_id
}

# route
output "apigatewayv2_route" {
  description = "Map containing the routes created and their attributes"
  value       = module.api_gateway.apigatewayv2_route
}
