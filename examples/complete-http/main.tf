provider "aws" {
  region = "eu-west-1"

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
}

locals {
  domain_name = "terraform-aws-modules.modules.tf"
}

###################
# HTTP API Gateway
###################

module "http" {
  source = "../../"

  name          = "${random_pet.this.id}-http"
  description   = "My awesome HTTP API Gateway"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  //    domain_name                 = local.domain_name
  //    domain_name_certificate_arn = module.acm.this_acm_certificate_arn
  create_api_domain_name = false

  integrations = {
    "POST /" = {
      lambda_arn             = module.lambda_function.this_lambda_function_arn
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }

    "$default" = {
      lambda_arn = module.lambda_function.this_lambda_function_arn
    }

  }

  tags = {
    Name = "dev-api-new"
  }
}

##################
# Extra resources
##################

resource "random_pet" "this" {
  length = 2
}

######
# ACM
######
// // 5.6.2020:
////// Error: Error requesting certificate: LimitExceededException: Error: you have reached your limit of 20 certificates in the last year.
//data "aws_route53_zone" "this" {
//  name = local.domain_name
//}
//
//module "acm" {
//  source  = "terraform-aws-modules/acm/aws"
//  version = "~> 2.0"
//
//  domain_name = local.domain_name # trimsuffix(data.aws_route53_zone.this.name, ".") # Terraform >= 0.12.17
//  zone_id     = data.aws_route53_zone.this.id
//}

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

data "null_data_source" "downloaded_package" {
  inputs = {
    id       = null_resource.download_package.id
    filename = local.downloaded
  }
}

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 1.0"

  function_name = "${random_pet.this.id}-lambda"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.8"

  create_package         = false
  local_existing_package = data.null_data_source.downloaded_package.outputs["filename"]
}
