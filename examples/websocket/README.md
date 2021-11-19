# AWS Websocket API example

Configuration in this directory creates an AWS Websocket API.
This example is based off of https://github.com/aws-samples/simple-websockets-chat-app

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

## Testing the chat API

To test the WebSocket API, you can use [wscat](https://github.com/websockets/wscat), an open-source command line tool.

1. [Install NPM](https://www.npmjs.com/get-npm).
2. Install wscat:

```bash
$ npm install -g wscat
```

3. On the console, connect to your published API endpoint by executing the following command:

```bash
$ wscat -c wss://{YOUR-API-ID}.execute-api.{YOUR-REGION}.amazonaws.com/{STAGE}
```

4. To test the sendMessage function, send a JSON message like the following example. The Lambda function sends it back using the callback URL:

```bash
$ wscat -c wss://{YOUR-API-ID}.execute-api.{YOUR-REGION}.amazonaws.com/{STAGE}
connected (press CTRL+C to quit)
> {"action":"sendmessage", "data":"hello world"}
< hello world
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.35 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.35 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0 |

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
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apigatewayv2_api_api_endpoint"></a> [apigatewayv2\_api\_api\_endpoint](#output\_apigatewayv2\_api\_api\_endpoint) | The URI of the API |
| <a name="output_apigatewayv2_api_arn"></a> [apigatewayv2\_api\_arn](#output\_apigatewayv2\_api\_arn) | The ARN of the API |
| <a name="output_apigatewayv2_api_execution_arn"></a> [apigatewayv2\_api\_execution\_arn](#output\_apigatewayv2\_api\_execution\_arn) | The ARN prefix to be used in an aws\_lambda\_permission's source\_arn attribute or in an aws\_iam\_policy to authorize access to the @connections API. |
| <a name="output_apigatewayv2_api_id"></a> [apigatewayv2\_api\_id](#output\_apigatewayv2\_api\_id) | The API identifier |
| <a name="output_apigatewayv2_api_mapping_id"></a> [apigatewayv2\_api\_mapping\_id](#output\_apigatewayv2\_api\_mapping\_id) | The API mapping identifier |
| <a name="output_apigatewayv2_domain_name_api_mapping_selection_expression"></a> [apigatewayv2\_domain\_name\_api\_mapping\_selection\_expression](#output\_apigatewayv2\_domain\_name\_api\_mapping\_selection\_expression) | The API mapping selection expression for the domain name |
| <a name="output_apigatewayv2_domain_name_arn"></a> [apigatewayv2\_domain\_name\_arn](#output\_apigatewayv2\_domain\_name\_arn) | The ARN of the domain name |
| <a name="output_apigatewayv2_domain_name_configuration"></a> [apigatewayv2\_domain\_name\_configuration](#output\_apigatewayv2\_domain\_name\_configuration) | The domain name configuration |
| <a name="output_apigatewayv2_domain_name_hosted_zone_id"></a> [apigatewayv2\_domain\_name\_hosted\_zone\_id](#output\_apigatewayv2\_domain\_name\_hosted\_zone\_id) | The Amazon Route 53 Hosted Zone ID of the endpoint |
| <a name="output_apigatewayv2_domain_name_id"></a> [apigatewayv2\_domain\_name\_id](#output\_apigatewayv2\_domain\_name\_id) | The domain name identifier |
| <a name="output_apigatewayv2_domain_name_target_domain_name"></a> [apigatewayv2\_domain\_name\_target\_domain\_name](#output\_apigatewayv2\_domain\_name\_target\_domain\_name) | The target domain name |
| <a name="output_apigatewayv2_route"></a> [apigatewayv2\_route](#output\_apigatewayv2\_route) | Map containing the routes created and their attributes |
| <a name="output_apigatewayv2_stage_arn"></a> [apigatewayv2\_stage\_arn](#output\_apigatewayv2\_stage\_arn) | The default stage ARN |
| <a name="output_apigatewayv2_stage_domain_name"></a> [apigatewayv2\_stage\_domain\_name](#output\_apigatewayv2\_stage\_domain\_name) | Domain name of the stage (useful for CloudFront distribution) |
| <a name="output_apigatewayv2_stage_execution_arn"></a> [apigatewayv2\_stage\_execution\_arn](#output\_apigatewayv2\_stage\_execution\_arn) | The ARN prefix to be used in an aws\_lambda\_permission's source\_arn attribute or in an aws\_iam\_policy to authorize access to the @connections API. |
| <a name="output_apigatewayv2_stage_id"></a> [apigatewayv2\_stage\_id](#output\_apigatewayv2\_stage\_id) | The default stage identifier |
| <a name="output_apigatewayv2_stage_invoke_url"></a> [apigatewayv2\_stage\_invoke\_url](#output\_apigatewayv2\_stage\_invoke\_url) | The URL to invoke the API pointing to the stage |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
