output "test_curl_command" {
  description = "Curl command to test API endpoint using mTLS"
  value       = "curl --key ./my-key.key --cert ./my-cert.pem https://${var.domain_name} | jq"
}

################################################################################
# API Gateway
################################################################################

output "api_id" {
  description = "The API identifier"
  value       = module.api_gateway.api_id
}

output "api_endpoint" {
  description = "URI of the API, of the form `https://{api-id}.execute-api.{region}.amazonaws.com` for HTTP APIs and `wss://{api-id}.execute-api.{region}.amazonaws.com` for WebSocket APIs"
  value       = module.api_gateway.api_endpoint
}

output "api_arn" {
  description = "The ARN of the API"
  value       = module.api_gateway.api_arn
}

output "api_execution_arn" {
  description = "The ARN prefix to be used in an `aws_lambda_permission`'s `source_arn` attribute or in an `aws_iam_policy` to authorize access to the `@connections` API"
  value       = module.api_gateway.api_execution_arn
}

################################################################################
# Authorizer(s)
################################################################################

output "authorizers" {
  description = "Map of API Gateway Authorizer(s) created and their attributes"
  value       = module.api_gateway.authorizers
}

################################################################################
# Domain Name
################################################################################

output "domain_name_id" {
  description = "The domain name identifier"
  value       = module.api_gateway.domain_name_id
}

output "domain_name_arn" {
  description = "The ARN of the domain name"
  value       = module.api_gateway.domain_name_arn
}

output "domain_name_api_mapping_selection_expression" {
  description = "The API mapping selection expression for the domain name"
  value       = module.api_gateway.domain_name_api_mapping_selection_expression
}

output "domain_name_configuration" {
  description = "The domain name configuration"
  value       = module.api_gateway.domain_name_configuration
}

output "domain_name_target_domain_name" {
  description = "The target domain name"
  value       = module.api_gateway.domain_name_target_domain_name
}

output "domain_name_hosted_zone_id" {
  description = "The Amazon Route 53 Hosted Zone ID of the endpoint"
  value       = module.api_gateway.domain_name_hosted_zone_id
}

################################################################################
# Domain - Certificate
################################################################################

output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = module.api_gateway.acm_certificate_arn
}

################################################################################
# Integration(s)
################################################################################

output "integrations" {
  description = "Map of the integrations created and their attributes"
  value       = module.api_gateway.integrations
}

################################################################################
# Route(s)
################################################################################

output "routes" {
  description = "Map of the routes created and their attributes"
  value       = module.api_gateway.routes
}

################################################################################
# Stage
################################################################################

output "stage_id" {
  description = "The stage identifier"
  value       = module.api_gateway.stage_id
}

output "stage_domain_name" {
  description = "Domain name of the stage (useful for CloudFront distribution)"
  value       = module.api_gateway.stage_domain_name
}

output "stage_arn" {
  description = "The stage ARN"
  value       = module.api_gateway.stage_arn
}

output "stage_execution_arn" {
  description = "The ARN prefix to be used in an aws_lambda_permission's source_arn attribute or in an aws_iam_policy to authorize access to the @connections API"
  value       = module.api_gateway.stage_execution_arn
}

output "stage_invoke_url" {
  description = "The URL to invoke the API pointing to the stage"
  value       = module.api_gateway.stage_invoke_url
}

################################################################################
# Stage Access Logs - Log Group
################################################################################

output "stage_access_logs_cloudwatch_log_group_name" {
  description = "Name of cloudwatch log group created"
  value       = module.api_gateway.stage_access_logs_cloudwatch_log_group_name
}

output "stage_access_logs_cloudwatch_log_group_arn" {
  description = "Arn of cloudwatch log group created"
  value       = module.api_gateway.stage_access_logs_cloudwatch_log_group_arn
}

################################################################################
# VPC Link
################################################################################

output "vpc_links" {
  description = "Map of VPC links created and their attributes"
  value       = module.api_gateway.vpc_links
}
