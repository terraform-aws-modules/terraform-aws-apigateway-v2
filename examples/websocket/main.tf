provider "aws" {
  region = local.region

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true

  # skip_requesting_account_id should be disabled to generate valid ARN in apigatewayv2_api_execution_arn
  skip_requesting_account_id = false
}

locals {
  name   = "websocket"
  region = "eu-west-1"

  tags = {
    Name        = local.name
    Environment = "dev"
  }
}

##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}

resource "aws_cloudwatch_log_group" "logs" {
  name = random_pet.this.id
}

resource "aws_api_gateway_account" "logs" {
  cloudwatch_role_arn = aws_iam_role.cloudwatch.arn
}

resource "aws_iam_role" "cloudwatch" {
  name = "api_gateway_cloudwatch_global"

  assume_role_policy = <<-EOT
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "",
        "Effect": "Allow",
        "Principal": {
          "Service": "apigateway.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOT

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"]

  tags = local.tags
}

########################
# Websocket API Gateway
########################

module "connect_lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2"

  function_name = "${local.name}-onConnect"
  description   = "Websocket onConnect handler"
  source_path   = ["function/onConnect.js"]
  handler       = "onConnect.handler"
  runtime       = "nodejs14.x"
  memory_size   = 256

  publish = true

  environment_variables = {
    TABLE_NAME = module.dynamodb_table.dynamodb_table_id
  }

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service   = "apigateway"
      principal = "apigateway.amazonaws.com"
    }
  }

  attach_policy_statements = true
  policy_statements = {
    dynamodb = {
      effect = "Allow",
      actions = [
        "dynamodb:GetItem",
        "dynamodb:DeleteItem",
        "dynamodb:PutItem",
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:UpdateItem",
        "dynamodb:BatchWriteItem",
        "dynamodb:BatchGetItem",
        "dynamodb:DescribeTable",
        "dynamodb:ConditionCheckItem",
      ],
      resources = [
        module.dynamodb_table.dynamodb_table_arn,
        "${module.dynamodb_table.dynamodb_table_arn}/index/*"
      ]
    }
  }

  tags = local.tags
}


module "disconnect_lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2"

  function_name = "${local.name}-onDisconnect"
  description   = "Websocket onDisconnect handler"
  source_path   = ["function/onDisconnect.js"]
  handler       = "onDisconnect.handler"
  runtime       = "nodejs14.x"
  memory_size   = 256

  publish = true

  environment_variables = {
    TABLE_NAME = module.dynamodb_table.dynamodb_table_id
  }

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service   = "apigateway"
      principal = "apigateway.amazonaws.com"
    }
  }

  attach_policy_statements = true
  policy_statements = {
    dynamodb = {
      effect = "Allow",
      actions = [
        "dynamodb:GetItem",
        "dynamodb:DeleteItem",
        "dynamodb:PutItem",
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:UpdateItem",
        "dynamodb:BatchWriteItem",
        "dynamodb:BatchGetItem",
        "dynamodb:DescribeTable",
        "dynamodb:ConditionCheckItem",
      ],
      resources = [
        module.dynamodb_table.dynamodb_table_arn,
        "${module.dynamodb_table.dynamodb_table_arn}/index/*"
      ]
    }
  }

  tags = local.tags
}


module "send_message_lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 2"

  function_name = "${local.name}-sendMessage"
  description   = "Websocket sendMessage handler"
  source_path   = ["function/sendMessage.js"]
  handler       = "sendMessage.handler"
  runtime       = "nodejs14.x"
  memory_size   = 256

  publish = true

  environment_variables = {
    TABLE_NAME = module.dynamodb_table.dynamodb_table_id
  }

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service   = "apigateway"
      principal = "apigateway.amazonaws.com"
    }
  }

  attach_policy_statements = true
  policy_statements = {
    manage_connections = {
      effect    = "Allow",
      actions   = ["execute-api:ManageConnections"],
      resources = ["${module.api_gateway.apigatewayv2_api_execution_arn}/*"]
    }
    dynamodb = {
      effect = "Allow",
      actions = [
        "dynamodb:GetItem",
        "dynamodb:DeleteItem",
        "dynamodb:PutItem",
        "dynamodb:Scan",
        "dynamodb:Query",
        "dynamodb:UpdateItem",
        "dynamodb:BatchWriteItem",
        "dynamodb:BatchGetItem",
        "dynamodb:DescribeTable",
        "dynamodb:ConditionCheckItem",
      ],
      resources = [
        module.dynamodb_table.dynamodb_table_arn,
        "${module.dynamodb_table.dynamodb_table_arn}/index/*"
      ]
    }
  }

  tags = local.tags
}

module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 1"

  name     = local.name
  hash_key = "connection_id"

  attributes = [
    {
      name = "connection_id"
      type = "S"
    }
  ]

  tags = local.tags
}

module "api_gateway" {
  source = "../../"

  name                       = random_pet.this.id
  description                = "My awesome AWS Websocket API Gateway"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"

  default_stage_name     = "Prod"
  create_api_domain_name = false

  default_route_settings = {
    detailed_metrics_enabled = true
    throttling_burst_limit   = 5000
    throttling_rate_limit    = 10000
  }

  default_stage_access_log_destination_arn = aws_cloudwatch_log_group.logs.arn
  default_stage_access_log_format = jsonencode({
    context = {
      domainName              = "$context.domainName"
      httpMethod              = "$context.httpMethod"
      integrationErrorMessage = "$context.integrationErrorMessage"
      protocol                = "$context.protocol"
      requestId               = "$context.requestId"
      requestTime             = "$context.requestTime"
      responseLength          = "$context.responseLength"
      routeKey                = "$context.routeKey"
      stage                   = "$context.stage"
      status                  = "$context.status"
      error = {
        message       = "$context.error.message"
        messageString = "$context.error.messageString"
        responseType  = "$context.error.responseType"
      }
      identity = {
        sourceIP = "$context.identity.sourceIp"
      }
      integration = {
        error             = "$context.integration.error"
        integrationStatus = "$context.integration.integrationStatus"
      }
    }
  })

  integrations = {
    "$connect" = {
      operation_name   = "ConnectRoute"
      integration_type = "AWS_PROXY"
      route_key        = "$connect"
      lambda_arn       = module.connect_lambda_function.lambda_function_invoke_arn
    },
    "$disconnect" = {
      operation_name   = "DisconnectRoute"
      integration_type = "AWS_PROXY"
      route_key        = "$disconnect"
      lambda_arn       = module.disconnect_lambda_function.lambda_function_invoke_arn
    },
    "sendmessage" = {
      operation_name   = "SendRoute"
      integration_type = "AWS_PROXY"
      route_key        = "sendmessage"
      lambda_arn       = module.send_message_lambda_function.lambda_function_invoke_arn
    },
  }

  tags = local.tags
}

output "wss" {
  value = module.api_gateway.default_apigatewayv2_stage_invoke_url
}
