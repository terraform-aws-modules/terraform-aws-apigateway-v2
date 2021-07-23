module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "aws-ws-connection-handler"
  description   = "AWS WS connection handler"
  handler       = "handler.lambda_handler"
  runtime       = "python3.8"

  publish = true

  source_path = "./handler"

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.this_apigatewayv2_api_execution_arn}/*/*"
    }
  }

  attach_policy_statements = true
  policy_statements = {
    manage_connections = {
      effect    = "Allow",
      actions   = ["execute-api:ManageConnections"],
      resources = ["${module.api_gateway.default_apigatewayv2_stage_execution_arn}/*"]
    }
    dynamodb = {
      effect    = "Allow",
      actions   = ["dynamodb:GetItem", "dynamodb:PutItem", "dynamodb:DeleteItem"],
      resources = [module.dynamodb_table.this_dynamodb_table_arn]
    }

  }

}
