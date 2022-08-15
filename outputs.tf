output "apigatewayv2_api_id" {
  description = "The API identifier"
  value       = try(aws_apigatewayv2_api.this[0].id, "")
}

output "apigatewayv2_api_api_endpoint" {
  description = "The URI of the API"
  value       = try(aws_apigatewayv2_api.this[0].api_endpoint, "")
}

output "apigatewayv2_api_arn" {
  description = "The ARN of the API"
  value       = try(aws_apigatewayv2_api.this[0].arn, "")
}

output "apigatewayv2_api_execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API."
  value       = try(aws_apigatewayv2_api.this[0].execution_arn, "")
}

# default stage
output "default_apigatewayv2_stage_id" {
  description = "The default stage identifier"
  value       = try(aws_apigatewayv2_stage.default[0].id, "")
}

output "default_apigatewayv2_stage_arn" {
  description = "The default stage ARN"
  value       = try(aws_apigatewayv2_stage.default[0].arn, "")
}

output "default_apigatewayv2_stage_execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API."
  value       = try(aws_apigatewayv2_stage.default[0].execution_arn, "")
}

output "default_apigatewayv2_stage_invoke_url" {
  description = "The URL to invoke the API pointing to the stage"
  value       = try(aws_apigatewayv2_stage.default[0].invoke_url, "")
}

output "default_apigatewayv2_stage_domain_name" {
  description = "Domain name of the stage (useful for CloudFront distribution)"
  value       = replace(try(aws_apigatewayv2_stage.default[0].invoke_url, ""), "/^https?://([^/]*).*/", "$1")
}

# domain name
output "apigatewayv2_domain_name_id" {
  description = "The domain name identifier"
  value       = try(aws_apigatewayv2_domain_name.this[0].id, "")
}

output "apigatewayv2_domain_name_arn" {
  description = "The ARN of the domain name"
  value       = try(aws_apigatewayv2_domain_name.this[0].arn, "")
}

output "apigatewayv2_domain_name_api_mapping_selection_expression" {
  description = "The API mapping selection expression for the domain name"
  value       = try(aws_apigatewayv2_domain_name.this[0].api_mapping_selection_expression, "")
}

output "apigatewayv2_domain_name_configuration" {
  description = "The domain name configuration"
  value       = try(aws_apigatewayv2_domain_name.this[0].domain_name_configuration, "")
}

output "apigatewayv2_domain_name_target_domain_name" {
  description = "The target domain name"
  value       = try(aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].target_domain_name, "")
}

output "apigatewayv2_domain_name_hosted_zone_id" {
  description = "The Amazon Route 53 Hosted Zone ID of the endpoint"
  value       = try(aws_apigatewayv2_domain_name.this[0].domain_name_configuration[0].hosted_zone_id, "")
}

# api mapping
output "apigatewayv2_api_mapping_id" {
  description = "The API mapping identifier."
  value       = try(aws_apigatewayv2_api_mapping.this[0].id, "")
}

# route
# output "apigatewayv2_route_id" {
#  description = "The default route identifier."
#  value       = try(aws_apigatewayv2_route.this[0].id, "")
# }

# VPC link
output "apigatewayv2_vpc_link_id" {
  description = "The map of VPC Link identifiers"
  value       = { for k, v in aws_apigatewayv2_vpc_link.this : k => v.id }
}

output "apigatewayv2_vpc_link_arn" {
  description = "The map of VPC Link ARNs"
  value       = { for k, v in aws_apigatewayv2_vpc_link.this : k => v.arn }
}

output "apigatewayv2_authorizer_id" {
  description = "The map of API Gateway Authorizer identifiers"
  value       = { for k, v in aws_apigatewayv2_authorizer.this : k => v.id }
}
