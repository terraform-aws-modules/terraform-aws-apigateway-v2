# API Gateway
output "this_apigatewayv2_api_endpoint" {
  description = "The URI of the API"
  value       = module.api_gateway.this_apigatewayv2_api_api_endpoint
}

output "this_apigatewayv2_vpc_link_arn" {
  description = "The ARN of the VPC Link"
  value       = module.api_gateway.this_apigatewayv2_vpc_link_arn
}

output "this_apigatewayv2_vpc_link_id" {
  description = "The identifier of the VPC Link"
  value       = module.api_gateway.this_apigatewayv2_vpc_link_id
}
