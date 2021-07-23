module "heartbeat_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "aws-ws-heartbeat"
  description   = "AWS WS Test Heartbeart"
  handler       = "handler.lambda_handler"
  runtime       = "python3.8"

  publish = true

  source_path = "./heartbeat"

  allowed_triggers = {
    RunHeartbeat = {
      principal  = "events.amazonaws.com"
      source_arn = aws_cloudwatch_event_rule.heartbeat.arn
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
      actions   = ["dynamodb:GetItem", "dynamodb:Scan"],
      resources = [module.dynamodb_table.this_dynamodb_table_arn]
    }
  }
}


resource "aws_cloudwatch_event_target" "send_heartbeat" {
  arn  = module.heartbeat_function.this_lambda_function_arn
  rule = aws_cloudwatch_event_rule.heartbeat.name
}

resource "local_file" "api_domain" {
  filename        = "heartbeat/api_url"
  file_permission = "0666"
  content         = "${replace(module.api_gateway.default_apigatewayv2_stage_invoke_url, "wss", "https")}/"
}
