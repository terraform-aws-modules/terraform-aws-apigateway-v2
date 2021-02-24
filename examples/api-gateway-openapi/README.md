# AWS API Gateway with OpenAPI example

This example uses an OpenAPI definition to define API gateway integration and route resources.

Placeholders in the OpenAPI template are populated during terraform apply.

## Usage

1. Change into this directory: `cd examples/api-gateway-openapi`.
1. Zip the Lambda handler JS file: `zip app.zip index.js`.
1. `terraform init` 
1. `terraform plan` 
1. `terraform apply` 

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

## More information

- [Working with OpenAPI definitions for HTTP APIs](https://docs.aws.amazon.com/apigateway/latest/developerguide/http-api-open-api.html)
- [Working with API Gateway extensions to OpenAPI](https://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-swagger-extensions.html)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14 |
| aws | >= 3.29.1, ~> 3 |
| local | ~> 2 |
| null | ~> 3 |
| template | ~> 2 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 3.29.1, ~> 3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| api_gateway | ../../ |  |
| context | git::https://github.com/cloudposse/terraform-null-label.git?ref=0.24.1 |  |

## Resources

| Name |
|------|
| [aws_cloudwatch_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) |
| [aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) |
| [aws_lambda_function](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_function) |
| [aws_lambda_permission](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lambda_permission) |

## Inputs

No input.

## Outputs

No output.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
