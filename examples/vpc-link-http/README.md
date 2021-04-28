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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.59 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | >= 2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | terraform-aws-modules/alb/aws | ~> 6.0 |
| <a name="module_alb_security_group"></a> [alb\_security\_group](#module\_alb\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.0 |
| <a name="module_api_gateway"></a> [api\_gateway](#module\_api\_gateway) | ../../ |  |
| <a name="module_api_gateway_security_group"></a> [api\_gateway\_security\_group](#module\_api\_gateway\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.0 |
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | terraform-aws-modules/lambda/aws | ~> 2.0 |
| <a name="module_lambda_security_group"></a> [lambda\_security\_group](#module\_lambda\_security\_group) | terraform-aws-modules/security-group/aws | ~> 4.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws |  ~> 3.0 |

## Resources

| Name | Type |
|------|------|
| [null_resource.download_package](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apigatewayv2_api_endpoint"></a> [apigatewayv2\_api\_endpoint](#output\_apigatewayv2\_api\_endpoint) | The URI of the API |
| <a name="output_apigatewayv2_vpc_link_arn"></a> [apigatewayv2\_vpc\_link\_arn](#output\_apigatewayv2\_vpc\_link\_arn) | The ARN of the VPC Link |
| <a name="output_apigatewayv2_vpc_link_id"></a> [apigatewayv2\_vpc\_link\_id](#output\_apigatewayv2\_vpc\_link\_id) | The identifier of the VPC Link |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
