# Websocket AWS API Gateway examples

Configuration in this directory creates AWS API Gateway with Domain Name, ACM Certificate, and integrates it with Lambda and Step Function and shows the variety of supported features.


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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.35 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.35 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_gateway"></a> [api\_gateway](#module\_api\_gateway) | ../../ | n/a |
| <a name="module_connect_lambda_function"></a> [connect\_lambda\_function](#module\_connect\_lambda\_function) | terraform-aws-modules/lambda/aws | ~> 2 |
| <a name="module_disconnect_lambda_function"></a> [disconnect\_lambda\_function](#module\_disconnect\_lambda\_function) | terraform-aws-modules/lambda/aws | ~> 2 |
| <a name="module_dynamodb_table"></a> [dynamodb\_table](#module\_dynamodb\_table) | terraform-aws-modules/dynamodb-table/aws | ~> 1 |
| <a name="module_send_message_lambda_function"></a> [send\_message\_lambda\_function](#module\_send\_message\_lambda\_function) | terraform-aws-modules/lambda/aws | ~> 2 |

## Resources

| Name | Type |
|------|------|
| [aws_api_gateway_account.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_account) | resource |
| [aws_cloudwatch_log_group.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_iam_role.cloudwatch](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_wss"></a> [wss](#output\_wss) | n/a |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
