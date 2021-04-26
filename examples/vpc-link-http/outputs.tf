# API Gateway
output "apigatewayv2_api_endpoint" {
  description = "The URI of the API"
  value       = module.api_gateway.apigatewayv2_api_api_endpoint
}

output "apigatewayv2_vpc_link_arn" {
  description = "The ARN of the VPC Link"
  value       = module.api_gateway.apigatewayv2_vpc_link_arn
}

output "apigatewayv2_vpc_link_id" {
  description = "The identifier of the VPC Link"
  value       = module.api_gateway.apigatewayv2_vpc_link_id
}
