output "this_apigatewayv2_api_id" {
  description = "The API identifier"
  value       = element(concat(aws_apigatewayv2_api.this.*.id, list("")), 0)
}

output "this_apigatewayv2_api_api_endpoint" {
  description = "The URI of the API"
  value       = element(concat(aws_apigatewayv2_api.this.*.api_endpoint, list("")), 0)
}

output "this_apigatewayv2_api_arn" {
  description = "The ARN of the API"
  value       = element(concat(aws_apigatewayv2_api.this.*.arn, list("")), 0)
}

output "this_apigatewayv2_api_execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API."
  value       = element(concat(aws_apigatewayv2_api.this.*.execution_arn, list("")), 0)
}

// default stage
output "default_apigatewayv2_stage_id" {
  description = "The default stage identifier"
  value       = element(concat(aws_apigatewayv2_stage.default.*.id, list("")), 0)
}

output "default_apigatewayv2_stage_arn" {
  description = "The default stage ARN"
  value       = element(concat(aws_apigatewayv2_stage.default.*.arn, list("")), 0)
}

output "default_apigatewayv2_stage_execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API."
  value       = element(concat(aws_apigatewayv2_stage.default.*.execution_arn, list("")), 0)
}

output "default_apigatewayv2_stage_invoke_url" {
  description = "The URL to invoke the API pointing to the stage"
  value       = element(concat(aws_apigatewayv2_stage.default.*.invoke_url, list("")), 0)
}

// domain name
output "this_apigatewayv2_domain_name_id" {
  description = "The domain name identifier"
  value       = element(concat(aws_apigatewayv2_domain_name.this.*.id, list("")), 0)
}

output "this_apigatewayv2_domain_name_arn" {
  description = "The ARN of the domain name"
  value       = element(concat(aws_apigatewayv2_domain_name.this.*.arn, list("")), 0)
}

output "this_apigatewayv2_domain_name_api_mapping_selection_expression" {
  description = "The API mapping selection expression for the domain name."
  value       = element(concat(aws_apigatewayv2_domain_name.this.*.api_mapping_selection_expression, list("")), 0)
}

output "this_apigatewayv2_domain_name_configuration" {
  description = "The ARN of the domain name"
  value       = element(concat(aws_apigatewayv2_domain_name.this.*.domain_name_configuration, list("")), 0)
}

// api mapping
output "this_apigatewayv2_api_mapping_id" {
  description = "The API mapping identifier."
  value       = element(concat(aws_apigatewayv2_api_mapping.this.*.id, list("")), 0)
}

// route
//output "this_apigatewayv2_route_id" {
//  description = "The default route identifier."
//  value       = element(concat(aws_apigatewayv2_route.this.*.id, list("")), 0)
//}

// vpc link
output "this_apigatewayv2_vpc_link_id" {
  description = "The VPC Link identifier"
  value       = element(concat(aws_apigatewayv2_vpc_link.this.*.id, list("")), 0)
}

output "this_apigatewayv2_vpc_link_arn" {
  description = "The VPC Link ARN"
  value       = element(concat(aws_apigatewayv2_vpc_link.this.*.arn, list("")), 0)
}
