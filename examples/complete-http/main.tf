provider "aws" {
  region = local.region
}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-west-1"

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

  # API
  body = templatefile("api.yaml", {
    example_function_arn = module.lambda_function.lambda_function_arn
  })

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  description      = "My awesome HTTP API Gateway"
  fail_on_warnings = false
  name             = local.name
  protocol_type    = "HTTP"

  # Authorizer(s)
  authorizers = {
    "cognito" = {
      authorizer_type  = "JWT"
      identity_sources = "$request.header.Authorization"
      name             = "cognito"
      jwt_configuration = {
        audience = ["d6a38afd-45d6-4874-d1aa-3c5c558aqcc2"]
        issuer   = "https://${aws_cognito_user_pool.this.endpoint}"
      }
    }
  }

  # Domain Name
  create_domain_name    = true
  domain_name           = var.domain_name
  create_domain_records = true
  create_certificate    = true
  subdomain             = "example"

  mutual_tls_authentication = {
    truststore_uri     = "s3://${module.s3_bucket.s3_bucket_id}/${aws_s3_object.truststore.id}"
    truststore_version = aws_s3_object.truststore.version_id
  }

  # Routes & Integration(s)
  integrations = {
    "ANY /" = {
      lambda_arn             = module.lambda_function.lambda_function_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }

    "GET /some-route" = {
      lambda_arn               = module.lambda_function.lambda_function_arn
      payload_format_version   = "2.0"
      authorization_type       = "JWT"
      authorizer_key           = "cognito"
      throttling_rate_limit    = 80
      throttling_burst_limit   = 40
      detailed_metrics_enabled = true
    }

    "GET /some-route-with-authorizer" = {
      lambda_arn             = module.lambda_function.lambda_function_arn
      payload_format_version = "2.0"
      authorizer_key         = "cognito"
    }

    "GET /some-route-with-authorizer-and-scope" = {
      lambda_arn             = module.lambda_function.lambda_function_arn
      payload_format_version = "2.0"
      authorization_type     = "JWT"
      authorizer_key         = "cognito"
      authorization_scopes   = ["user.id", "user.email"]
    }

    "GET /some-route-with-authorizer-and-different-scope" = {
      lambda_arn             = module.lambda_function.lambda_function_arn
      payload_format_version = "2.0"
      authorization_type     = "JWT"
      authorizer_key         = "cognito"
      authorization_scopes   = ["user.id", "user.email"]
    }

    "POST /start-step-function" = {
      integration_type    = "AWS_PROXY"
      integration_subtype = "StepFunctions-StartExecution"
      credentials_arn     = module.step_function.role_arn

      # Note: jsonencode is used to pass argument as a string
      request_parameters = jsonencode({
        StateMachineArn = module.step_function.state_machine_arn
        Input = jsonencode({
          "key1" : "value1",
          "key2" : "value2"
        })
      })

      payload_format_version = "1.0"
      timeout_milliseconds   = 12000
    }

    "$default" = {
      lambda_arn = module.lambda_function.lambda_function_arn
      tls_config = jsonencode({
        server_name_to_verify = var.domain_name
      })

      response_parameters = jsonencode([
        {
          status_code = 500
          mappings = {
            "append:header.header1" = "$context.requestId"
            "overwrite:statuscode"  = "403"
          }
        },
        {
          status_code = 404
          mappings = {
            "append:header.error" = "$stageVariables.environmentId"
          }
        }
      ])
    }
  }

  # Stage
  stage_access_log_settings = {
    create_log_group            = true
    log_group_retention_in_days = 7
    format = jsonencode({
      "requestId" : "$context.requestId",
      "extendedRequestId" : "$context.extendedRequestId",
      "ip" : "$context.identity.sourceIp",
      "caller" : "$context.identity.caller",
      "user" : "$context.identity.user",
      "requestTime" : "$context.requestTime",
      "httpMethod" : "$context.httpMethod",
      "resourcePath" : "$context.resourcePath",
      "status" : "$context.status",
      "protocol" : "$context.protocol",
      "responseLength" : "$context.responseLength",
      "domainName" : "$context.domainName",
      "errorMessage" : "$context.error.message",
      "errorResponseType" : "$context.error.responseType",
      "integrationErrorMessage" : "$context.integrationErrorMessage",
    })
  }

  stage_default_route_settings = {
    detailed_metrics_enabled = true
    throttling_burst_limit   = 100
    throttling_rate_limit    = 100
  }

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

resource "aws_cognito_user_pool" "this" {
  name = local.name

  tags = local.tags
}

module "step_function" {
  source  = "terraform-aws-modules/step-functions/aws"
  version = "~> 4.0"

  name      = local.name
  role_name = "${local.name}-step-function"
  trusted_entities = [
    "apigateway.amazonaws.com",
    "lambda.amazonaws.com",
  ]

  attach_policies_for_integrations = true
  service_integrations = {
    stepfunction = {
      stepfunction = ["*"]
    }
  }

  definition = <<-EOT
    {
      "Comment": "A Hello World example of the Amazon States Language using Pass states",
      "StartAt": "Hello",
      "States": {
        "Hello": {
          "Type": "Pass",
          "Result": "Hello",
          "Next": "World"
        },
        "World": {
          "Type": "Pass",
          "Result": "World",
          "End": true
        }
      }
    }
  EOT

  tags = local.tags
}

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 7.0"

  function_name = local.name
  description   = "My awesome lambda function"
  handler       = "lambda.handler"
  runtime       = "python3.12"

  publish     = true
  source_path = "lambda.py"

  cloudwatch_logs_retention_in_days = 7

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.api_execution_arn}/*/*"
    }
  }

  tags = local.tags
}

module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.0"

  bucket_prefix = "${local.name}-"

  # Allow deletion of non-empty bucket
  # Example usage only - not recommended for production
  force_destroy = true

  attach_deny_insecure_transport_policy = true
  attach_require_latest_tls_policy      = true

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = local.tags
}

resource "aws_s3_object" "truststore" {
  bucket  = module.s3_bucket.s3_bucket_id
  key     = "truststore.pem"
  content = tls_self_signed_cert.example.cert_pem
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "example" {
  is_ca_certificate = true
  private_key_pem   = tls_private_key.private_key.private_key_pem

  subject {
    common_name  = "example.com"
    organization = "ACME Examples, Inc"
  }

  validity_period_hours = 12

  allowed_uses = [
    "cert_signing",
    "server_auth",
  ]
}
