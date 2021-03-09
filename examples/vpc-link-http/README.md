# AWS API Gateway w/ VPC Links example

Configuration in this directory creates a private AWS API Gateway with VPC link and integrates it with a VPC bound resources (Lambda function and ALB).


## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.26 |
| aws | >= 2.59 |
| null | >= 2.0 |
| random | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| null | >= 2.0 |
| random | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| alb | terraform-aws-modules/alb/aws |  |
| alb_security_group | terraform-aws-modules/security-group/aws | ~> 3.0 |
| api_gateway | ../../ |  |
| api_gateway_security_group | terraform-aws-modules/security-group/aws | ~> 3.0 |
| lambda_function | terraform-aws-modules/lambda/aws | ~> 1.0 |
| lambda_security_group | terraform-aws-modules/security-group/aws | ~> 3.0 |
| vpc | terraform-aws-modules/vpc/aws |  ~> 2.0 |

## Resources

| Name |
|------|
| [null_data_source](https://registry.terraform.io/providers/hashicorp/null/latest/docs/data-sources/data_source) |
| [null_resource](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) |
| [random_pet](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| this\_apigatewayv2\_api\_endpoint | The URI of the API |
| this\_apigatewayv2\_vpc\_link\_arn | The ARN of the VPC Link |
| this\_apigatewayv2\_vpc\_link\_id | The identifier of the VPC Link |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
