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

> [!NOTE]
> It will take a few seconds on a new API for the endpoint to respond.
> If you see a 403 error, give it a few seconds and try again - only one new APIs that were just created.

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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.96 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_gateway"></a> [api\_gateway](#module\_api\_gateway) | ../../ | n/a |
| <a name="module_connect_lambda_function"></a> [connect\_lambda\_function](#module\_connect\_lambda\_function) | terraform-aws-modules/lambda/aws | ~> 4.0 |
| <a name="module_disconnect_lambda_function"></a> [disconnect\_lambda\_function](#module\_disconnect\_lambda\_function) | terraform-aws-modules/lambda/aws | ~> 4.0 |
| <a name="module_dynamodb_table"></a> [dynamodb\_table](#module\_dynamodb\_table) | terraform-aws-modules/dynamodb-table/aws | ~> 3.0 |
| <a name="module_send_message_lambda_function"></a> [send\_message\_lambda\_function](#module\_send\_message\_lambda\_function) | terraform-aws-modules/lambda/aws | ~> 4.0 |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acm_certificate_arn"></a> [acm\_certificate\_arn](#output\_acm\_certificate\_arn) | The ARN of the certificate |
| <a name="output_api_arn"></a> [api\_arn](#output\_api\_arn) | The ARN of the API |
| <a name="output_api_endpoint"></a> [api\_endpoint](#output\_api\_endpoint) | URI of the API, of the form `https://{api-id}.execute-api.{region}.amazonaws.com` for HTTP APIs and `wss://{api-id}.execute-api.{region}.amazonaws.com` for WebSocket APIs |
| <a name="output_api_execution_arn"></a> [api\_execution\_arn](#output\_api\_execution\_arn) | The ARN prefix to be used in an `aws_lambda_permission`'s `source_arn` attribute or in an `aws_iam_policy` to authorize access to the `@connections` API |
| <a name="output_api_id"></a> [api\_id](#output\_api\_id) | The API identifier |
| <a name="output_authorizers"></a> [authorizers](#output\_authorizers) | Map of API Gateway Authorizer(s) created and their attributes |
| <a name="output_domain_name_api_mapping_selection_expression"></a> [domain\_name\_api\_mapping\_selection\_expression](#output\_domain\_name\_api\_mapping\_selection\_expression) | The API mapping selection expression for the domain name |
| <a name="output_domain_name_arn"></a> [domain\_name\_arn](#output\_domain\_name\_arn) | The ARN of the domain name |
| <a name="output_domain_name_configuration"></a> [domain\_name\_configuration](#output\_domain\_name\_configuration) | The domain name configuration |
| <a name="output_domain_name_hosted_zone_id"></a> [domain\_name\_hosted\_zone\_id](#output\_domain\_name\_hosted\_zone\_id) | The Amazon Route 53 Hosted Zone ID of the endpoint |
| <a name="output_domain_name_id"></a> [domain\_name\_id](#output\_domain\_name\_id) | The domain name identifier |
| <a name="output_domain_name_target_domain_name"></a> [domain\_name\_target\_domain\_name](#output\_domain\_name\_target\_domain\_name) | The target domain name |
| <a name="output_integrations"></a> [integrations](#output\_integrations) | Map of the integrations created and their attributes |
| <a name="output_routes"></a> [routes](#output\_routes) | Map of the routes created and their attributes |
| <a name="output_stage_access_logs_cloudwatch_log_group_arn"></a> [stage\_access\_logs\_cloudwatch\_log\_group\_arn](#output\_stage\_access\_logs\_cloudwatch\_log\_group\_arn) | Arn of cloudwatch log group created |
| <a name="output_stage_access_logs_cloudwatch_log_group_name"></a> [stage\_access\_logs\_cloudwatch\_log\_group\_name](#output\_stage\_access\_logs\_cloudwatch\_log\_group\_name) | Name of cloudwatch log group created |
| <a name="output_stage_arn"></a> [stage\_arn](#output\_stage\_arn) | The stage ARN |
| <a name="output_stage_domain_name"></a> [stage\_domain\_name](#output\_stage\_domain\_name) | Domain name of the stage (useful for CloudFront distribution) |
| <a name="output_stage_execution_arn"></a> [stage\_execution\_arn](#output\_stage\_execution\_arn) | The ARN prefix to be used in an aws\_lambda\_permission's source\_arn attribute or in an aws\_iam\_policy to authorize access to the @connections API |
| <a name="output_stage_id"></a> [stage\_id](#output\_stage\_id) | The stage identifier |
| <a name="output_stage_invoke_url"></a> [stage\_invoke\_url](#output\_stage\_invoke\_url) | The URL to invoke the API pointing to the stage |
| <a name="output_vpc_links"></a> [vpc\_links](#output\_vpc\_links) | Map of VPC links created and their attributes |
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/blob/master/LICENSE).
