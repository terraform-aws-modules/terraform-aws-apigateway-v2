provider "aws" {
  region = "eu-west-2"

  # Make it faster by skipping some things
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true

  # skip_requesting_account_id should be disabled to generate valid ARN in apigatewayv2_api_execution_arn
  skip_requesting_account_id = false
}

locals {
  domain_name = "terraform-aws-modules.modules.tf" # trimsuffix(data.aws_route53_zone.this.name, ".")
  subdomain   = "complete-http"
}

###################
# HTTP API Gateway
###################

module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"


  name                       = "aws-ws-test"
  description                = "My awesome AWS Websocket API Gateway"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"

  create_api_domain_name = false

  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.logs.arn
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  integrations = {
    "$connect" = {
      lambda_arn = module.lambda_function.this_lambda_function_invoke_arn
    },
    "$disconnect" = {
      lambda_arn = module.lambda_function.this_lambda_function_invoke_arn
    },
    "$default" = {
      lambda_arn = module.lambda_function.this_lambda_function_invoke_arn
    }

  }

  tags = {
    Name = "dev-api-new"
  }
}

output "execute_uri" {
  value = module.api_gateway.default_apigatewayv2_stage_invoke_url
}


resource "aws_cloudwatch_log_group" "logs" {
  name = "aws-ws-test"
}
