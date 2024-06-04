provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-west-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

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
  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  description = "HTTP API Gateway with VPC links"
  name        = local.name

  # Custom Domain
  create_domain_name = false

  # Routes & Integration(s)
  routes = {
    "ANY /" = {
      integration = {
        uri                    = module.lambda_function.lambda_function_arn
        payload_format_version = "2.0"
        timeout_milliseconds   = 12000
      }
    }

    "GET /alb-internal-route" = {
      integration = {
        connection_type = "VPC_LINK"
        uri             = module.alb.listeners["default"].arn
        type            = "HTTP_PROXY"
        method          = "ANY"
        vpc_link_key    = "my-vpc"
      }
    }

    "$default" = {
      integration = {
        uri = module.lambda_function.lambda_function_arn
      }
    }
  }

  # VPC Link
  vpc_links = {
    my-vpc = {
      name               = local.name
      security_group_ids = [module.api_gateway_security_group.security_group_id]
      subnet_ids         = module.vpc.public_subnets
    }
  }

  tags = local.tags
}

################################################################################
# Supporting Resources
################################################################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 48)]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags
}

module "api_gateway_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = local.name
  description = "API Gateway group for example usage"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp"]

  egress_rules = ["all-all"]

  tags = local.tags
}

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name = local.name

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  # Disable for example
  enable_deletion_protection = false

  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  listeners = {
    default = {
      port     = 80
      protocol = "HTTP"
      fixed_response = {
        content_type = "text/plain"
        message_body = "Hello, World!"
        status_code  = "200"
      }
    }
  }

  tags = local.tags
}


locals {
  package_url = "https://raw.githubusercontent.com/terraform-aws-modules/terraform-aws-lambda/master/examples/fixtures/python-function.zip"
  downloaded  = "downloaded_package_${md5(local.package_url)}.zip"
}

resource "null_resource" "download_package" {
  triggers = {
    downloaded = local.downloaded
  }

  provisioner "local-exec" {
    command = "curl -L -o ${local.downloaded} ${local.package_url}"
  }
}

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 7.0"

  function_name = local.name
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.12"
  architectures = ["arm64"]
  publish       = true

  create_package         = false
  local_existing_package = local.downloaded

  cloudwatch_logs_retention_in_days = 7

  attach_network_policy  = true
  vpc_subnet_ids         = module.vpc.private_subnets
  vpc_security_group_ids = [module.lambda_security_group.security_group_id]

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.api_execution_arn}/*/*"
    }
  }

  tags = local.tags
}

module "lambda_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${local.name}-lambda"
  description = "Lambda security group for example usage"
  vpc_id      = module.vpc.vpc_id

  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.api_gateway_security_group.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1

  egress_rules = ["all-all"]

  tags = local.tags
}
