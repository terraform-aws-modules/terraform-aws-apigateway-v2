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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 2.59 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 2.59 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 3.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | ~> 3.0 |
| <a name="module_api_gateway"></a> [api\_gateway](#module\_api\_gateway) | ../../ |  |
| <a name="module_lambda_function"></a> [lambda\_function](#module\_lambda\_function) | terraform-aws-modules/lambda/aws | ~> 2.0 |
| <a name="module_step_function"></a> [step\_function](#module\_step\_function) | terraform-aws-modules/step-functions/aws | ~> 2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_authorizer.some_authorizer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_authorizer) | resource |
| [aws_cloudwatch_log_group.logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cognito_user_pool.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_route53_record.api](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.truststore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_object.truststore](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object) | resource |
| [null_resource.download_package](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [random_pet.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) | resource |
| [tls_private_key.private_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [tls_self_signed_cert.example](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/self_signed_cert) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_endpoint"></a> [api\_endpoint](#output\_api\_endpoint) | FQDN of an API endpoint |
| <a name="output_api_fqdn"></a> [api\_fqdn](#output\_api\_fqdn) | List of Route53 records |
| <a name="output_apigatewayv2_api_api_endpoint"></a> [apigatewayv2\_api\_api\_endpoint](#output\_apigatewayv2\_api\_api\_endpoint) | The URI of the API |
| <a name="output_apigatewayv2_domain_name_configuration"></a> [apigatewayv2\_domain\_name\_configuration](#output\_apigatewayv2\_domain\_name\_configuration) | The domain name configuration |
| <a name="output_apigatewayv2_domain_name_id"></a> [apigatewayv2\_domain\_name\_id](#output\_apigatewayv2\_domain\_name\_id) | The domain name identifier |
| <a name="output_apigatewayv2_hosted_zone_id"></a> [apigatewayv2\_hosted\_zone\_id](#output\_apigatewayv2\_hosted\_zone\_id) | The Amazon Route 53 Hosted Zone ID of the endpoint |
| <a name="output_apigatewayv2_target_domain_name"></a> [apigatewayv2\_target\_domain\_name](#output\_apigatewayv2\_target\_domain\_name) | The target domain name |
| <a name="output_lambda_cloudwatch_log_group_arn"></a> [lambda\_cloudwatch\_log\_group\_arn](#output\_lambda\_cloudwatch\_log\_group\_arn) | The ARN of the Cloudwatch Log Group |
| <a name="output_lambda_function_arn"></a> [lambda\_function\_arn](#output\_lambda\_function\_arn) | The ARN of the Lambda Function |
| <a name="output_lambda_function_invoke_arn"></a> [lambda\_function\_invoke\_arn](#output\_lambda\_function\_invoke\_arn) | The Invoke ARN of the Lambda Function |
| <a name="output_lambda_function_kms_key_arn"></a> [lambda\_function\_kms\_key\_arn](#output\_lambda\_function\_kms\_key\_arn) | The ARN for the KMS encryption key of Lambda Function |
| <a name="output_lambda_function_last_modified"></a> [lambda\_function\_last\_modified](#output\_lambda\_function\_last\_modified) | The date Lambda Function resource was last modified |
| <a name="output_lambda_function_name"></a> [lambda\_function\_name](#output\_lambda\_function\_name) | The name of the Lambda Function |
| <a name="output_lambda_function_qualified_arn"></a> [lambda\_function\_qualified\_arn](#output\_lambda\_function\_qualified\_arn) | The ARN identifying your Lambda Function Version |
| <a name="output_lambda_function_source_code_hash"></a> [lambda\_function\_source\_code\_hash](#output\_lambda\_function\_source\_code\_hash) | Base64-encoded representation of raw SHA-256 sum of the zip file |
| <a name="output_lambda_function_source_code_size"></a> [lambda\_function\_source\_code\_size](#output\_lambda\_function\_source\_code\_size) | The size in bytes of the function .zip file |
| <a name="output_lambda_function_version"></a> [lambda\_function\_version](#output\_lambda\_function\_version) | Latest published version of Lambda Function |
| <a name="output_lambda_layer_arn"></a> [lambda\_layer\_arn](#output\_lambda\_layer\_arn) | The ARN of the Lambda Layer with version |
| <a name="output_lambda_layer_created_date"></a> [lambda\_layer\_created\_date](#output\_lambda\_layer\_created\_date) | The date Lambda Layer resource was created |
| <a name="output_lambda_layer_layer_arn"></a> [lambda\_layer\_layer\_arn](#output\_lambda\_layer\_layer\_arn) | The ARN of the Lambda Layer without version |
| <a name="output_lambda_layer_source_code_size"></a> [lambda\_layer\_source\_code\_size](#output\_lambda\_layer\_source\_code\_size) | The size in bytes of the Lambda Layer .zip file |
| <a name="output_lambda_layer_version"></a> [lambda\_layer\_version](#output\_lambda\_layer\_version) | The Lambda Layer version |
| <a name="output_lambda_role_arn"></a> [lambda\_role\_arn](#output\_lambda\_role\_arn) | The ARN of the IAM role created for the Lambda Function |
| <a name="output_lambda_role_name"></a> [lambda\_role\_name](#output\_lambda\_role\_name) | The name of the IAM role created for the Lambda Function |
| <a name="output_local_filename"></a> [local\_filename](#output\_local\_filename) | The filename of zip archive deployed (if deployment was from local) |
| <a name="output_s3_object"></a> [s3\_object](#output\_s3\_object) | The map with S3 object data of zip archive deployed (if deployment was from S3) |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
