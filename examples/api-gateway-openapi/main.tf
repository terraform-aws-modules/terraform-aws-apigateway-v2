module "api_gateway" {
  source = "../../"

  name          = module.context.id
  description   = "My awesome HTTP API Gateway with OpenAPI"
  protocol_type = "HTTP"

  create_api_domain_name = false
  cors_configuration = {
    allow_headers = [
      "content-type",
      "x-amz-date",
      "authorization",
      "x-api-key",
      "x-amz-security-token",
      "x-amz-user-agent"
    ]
    allow_methods = [
      "*"
    ]
    allow_origins = [
      "*"
    ]
  }

  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.logs.arn
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  # Creates aws_apigatewayv2_integration and aws_apigatewayv2_route resources.
  body = templatefile("${path.module}/api.yaml", {
    example_function_arn = aws_lambda_function.main.arn
  })

  tags = {
    Name = "dev-api-new"
  }
}

resource "aws_cloudwatch_log_group" "logs" {
  name = "${module.context.id}-logs"
}

resource "aws_lambda_function" "main" {
  function_name = "${module.context.id}-lambda"
  handler       = "index.lambdaHandler"
  runtime       = "nodejs14.x"
  role          = aws_iam_role.lambda_execution_role.arn

  filename = "${path.module}/app.zip"

  environment {
    variables = {
      ENV = "dev"
    }
  }
}

resource "aws_lambda_permission" "main" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.function_name
  principal     = "apigateway.amazonaws.com"
  # /*/*/* = any stage, any HTTP method, any route
  source_arn = "${module.api_gateway.this_apigatewayv2_api_execution_arn}/*/*/*"
}

resource "aws_iam_role" "lambda_execution_role" {
  name = "${module.context.id}-execution-role"

  assume_role_policy = <<-EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
    }
  EOF

  managed_policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole",
  ]
}
