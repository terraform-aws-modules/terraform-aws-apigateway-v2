provider "aws" {
  region = local.region
}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-west-1"

  dynamodb_table_name = local.name
  dynamodb_crud_permissions = {
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

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-apigateway-v2"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# API Gateway Module
################################################################################

module "api_gateway" {
  source = "../../"

  name                       = local.name
  description                = "My awesome AWS Websocket API Gateway"
  protocol_type              = "WEBSOCKET"
  route_selection_expression = "$request.body.action"

  stage_name = "Prod"

  stage_default_route_settings = {
    detailed_metrics_enabled = true
    throttling_burst_limit   = 50
    throttling_rate_limit    = 100
  }

  stage_access_log_settings = {
    destination_arn = aws_cloudwatch_log_group.logs.arn
    format = jsonencode({
      context = {
        domainName              = "$context.domainName"
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
  }

  integrations = {
    "$connect" = {
      operation_name         = "ConnectRoute"
      integration_type       = "AWS_PROXY"
      route_key              = "$connect"
      lambda_arn             = module.connect_lambda_function.lambda_function_invoke_arn
      throttling_burst_limit = 50
      throttling_rate_limit  = 100
    },
    "$disconnect" = {
      operation_name         = "DisconnectRoute"
      integration_type       = "AWS_PROXY"
      route_key              = "$disconnect"
      lambda_arn             = module.disconnect_lambda_function.lambda_function_invoke_arn
      throttling_burst_limit = 50
      throttling_rate_limit  = 100
    },
    "sendmessage" = {
      operation_name         = "SendRoute"
      integration_type       = "AWS_PROXY"
      route_key              = "sendmessage"
      lambda_arn             = module.send_message_lambda_function.lambda_function_invoke_arn
      throttling_burst_limit = 50
      throttling_rate_limit  = 100
    },
  }

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

resource "aws_cloudwatch_log_group" "logs" {
  name = local.name
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

module "connect_lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.0"

  function_name = "${local.name}-onConnect"
  description   = "Websocket onConnect handler"
  source_path   = ["function/onConnect.js"]
  handler       = "onConnect.handler"
  runtime       = "nodejs16.x"
  memory_size   = 256
  publish       = true

  environment_variables = {
    TABLE_NAME = local.dynamodb_table_name
  }

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.api_execution_arn}/*/*"
    }
  }

  attach_policy_statements = true
  policy_statements = {
    dynamodb = local.dynamodb_crud_permissions
  }

  depends_on = [
    module.dynamodb_table
  ]

  tags = local.tags
}

module "disconnect_lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.0"

  function_name = "${local.name}-onDisconnect"
  description   = "Websocket onDisconnect handler"
  source_path   = ["function/onDisconnect.js"]
  handler       = "onDisconnect.handler"
  runtime       = "nodejs16.x"
  memory_size   = 256
  publish       = true

  environment_variables = {
    TABLE_NAME = local.dynamodb_table_name
  }

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.api_execution_arn}/*/*"
    }
  }

  attach_policy_statements = true
  policy_statements = {
    dynamodb = local.dynamodb_crud_permissions
  }

  depends_on = [
    module.dynamodb_table
  ]

  tags = local.tags
}

module "send_message_lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 4.0"

  function_name = "${local.name}-sendMessage"
  description   = "Websocket sendMessage handler"
  source_path   = ["function/sendMessage.js"]
  handler       = "sendMessage.handler"
  runtime       = "nodejs16.x"
  memory_size   = 256
  publish       = true

  environment_variables = {
    TABLE_NAME = local.dynamodb_table_name
  }

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.api_execution_arn}/*/*"
    }
  }

  attach_policy_statements = true
  policy_statements = {
    manage_connections = {
      effect    = "Allow",
      actions   = ["execute-api:ManageConnections"],
      resources = ["${module.api_gateway.api_execution_arn}/*"]
    }
    dynamodb = local.dynamodb_crud_permissions
  }

  depends_on = [
    module.dynamodb_table
  ]

  tags = local.tags
}

module "dynamodb_table" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "~> 3.0"

  name     = local.dynamodb_table_name
  hash_key = "connectionId"

  attributes = [
    {
      name = "connectionId"
      type = "S"
    }
  ]

  tags = local.tags
}
