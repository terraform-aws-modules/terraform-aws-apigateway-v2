locals {
  region = "eu-west-1"
}

provider "aws" {
  region = local.region

  # Make it faster by skipping something
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true

  # skip_requesting_account_id should be disabled to generate valid ARN in apigatewayv2_api_execution_arn
  skip_requesting_account_id = false
}

###################
# HTTP API Gateway
###################

module "api_gateway" {
  source = "../../"

  name          = "${random_pet.this.id}-http-vpc-links"
  description   = "HTTP API Gateway with VPC links"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  create_api_domain_name = false

  integrations = {
    "ANY /" = {
      lambda_arn             = module.lambda_function.lambda_function_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }

    "GET /alb-internal-route" = {
      connection_type    = "VPC_LINK"
      vpc_link           = "my-vpc"
      integration_uri    = module.alb.listeners["default"].arn
      integration_type   = "HTTP_PROXY"
      integration_method = "ANY"
    }

    "$default" = {
      lambda_arn = module.lambda_function.lambda_function_arn
    }
  }

  vpc_links = {
    my-vpc = {
      name               = "example"
      security_group_ids = [module.api_gateway_security_group.security_group_id]
      subnet_ids         = module.vpc.public_subnets
    }
  }

  tags = {
    Name = "private-api"
  }
}

################################
# Supporting resources
################################

resource "random_pet" "this" {
  length = 2
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "vpc-link-http"
  cidr = "10.0.0.0/16"

  azs             = ["${local.region}a", "${local.region}b", "${local.region}c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  single_nat_gateway = true
}

module "api_gateway_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "api-gateway-sg-${random_pet.this.id}"
  description = "API Gateway group for example usage"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp"]

  egress_rules = ["all-all"]
}


############################
# Application Load Balancer
############################

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name = "alb-${random_pet.this.id}"

  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

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

  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = module.vpc.vpc_cidr_block
    }
  }

  listeners = {
    default = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "lambda"
      }
    }
  }

  target_groups = {
    lambda = {
      name_prefix              = "l1-"
      target_type              = "lambda"
      target_id                = module.lambda_function.lambda_function_arn
      attach_lambda_permission = true
    }
  }
}


#############################################
# Using packaged function from Lambda module
#############################################

locals {
  package_url = "https://raw.githubusercontent.com/terraform-aws-modules/terraform-aws-lambda/master/examples/fixtures/python3.8-zip/existing_package.zip"
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

  function_name = "${random_pet.this.id}-lambda"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  publish = true

  create_package         = false
  local_existing_package = local.downloaded

  attach_network_policy  = true
  vpc_subnet_ids         = module.vpc.private_subnets
  vpc_security_group_ids = [module.lambda_security_group.security_group_id]

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*/*"
    }
  }
}

module "lambda_security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "lambda-sg-${random_pet.this.id}"
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
}
