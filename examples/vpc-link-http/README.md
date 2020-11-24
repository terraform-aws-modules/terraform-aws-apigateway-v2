# AWS API Gateway w/ VPC Links example

Configuration in this directory creates a private AWS API Gateway with VPC links and integrates it with a VPC bound Lambda function.


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
| terraform | >= 0.12.6 |
| aws | >= 2.59 |
| null | >= 2.0 |
| random | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| null | >= 2.0 |
| random | >= 2.0 |

## Inputs

No input.

## Outputs

| Name | Description |
|------|-------------|
| this\_apigatewayv2\_api\_endpoint | The URI of the API |
| this\_apigatewayv2\_vpc\_link\_arn | The ARN of the VPC Link |
| this\_apigatewayv2\_vpc\_link\_id | The identifier of the VPC Link |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
