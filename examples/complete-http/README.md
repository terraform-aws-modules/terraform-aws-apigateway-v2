# Complete AWS API Gateway (HTTP) examples

Configuration in this directory creates AWS API Gateway with Domain Name, ACM Certificate, and integrates it with Lambda and Step Function and shows the variety of supported features.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.96 |
| <a name="requirement_local"></a> [local](#requirement\_local) | >= 2.5 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.96 |
| <a name="provider_local"></a> [local](#provider\_local) | >= 2.5 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 2.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 3.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_gateway"></a> [api\_gateway](#module\_api\_gateway) | ../../ | n/a |
| <a name="module_api_gateway_disabled"></a> [api\_gateway\_disabled](#module\_api\_gateway\_disabled) | ../../ | n/a |
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | terraform-aws-modules/lambda/aws | ~> 7.0 |
| <a name="module_s3_bucket"></a> [s3\_bucket](#module\_s3\_bucket) | terraform-aws-modules/s3-bucket/aws | ~> 3.0 |
| <a name="module_step_function"></a> [step\_function](#module\_step\_function) | terraform-aws-modules/step-functions/aws | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_authorizer.external](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_authorizer) | resource |
| [aws_cognito_user_pool.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_s3_object.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [local_file.key](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [local_file.pem](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.download_package](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Custom domain name to use on API Gateway endpoint | `string` | `"terraform-aws-modules.modules.tf"` | no |

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
| <a name="output_test_curl_command"></a> [test\_curl\_command](#output\_test\_curl\_command) | Curl command to test API endpoint using mTLS |
| <a name="output_vpc_links"></a> [vpc\_links](#output\_vpc\_links) | Map of VPC links created and their attributes |
<!-- END_TF_DOCS -->

Apache-2.0 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/blob/master/LICENSE).
