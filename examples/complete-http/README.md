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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | >= 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | >= 3.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |
| <a name="provider_null"></a> [null](#provider\_null) | >= 2.0 |
| <a name="provider_random"></a> [random](#provider\_random) | >= 2.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | >= 3.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | ~> 3.0 |
| <a name="module_api_gateway"></a> [api\_gateway](#module\_api\_gateway) | ../../ | n/a |
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

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Custom domain name to use on API Gateway endpoint | `string` | `"terraform-aws-modules.modules.tf"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_api_arn"></a> [api\_arn](#output\_api\_arn) | The ARN of the API |
| <a name="output_api_endpoint"></a> [api\_endpoint](#output\_api\_endpoint) | The URI of the API |
| <a name="output_api_execution_arn"></a> [api\_execution\_arn](#output\_api\_execution\_arn) | The ARN prefix to be used in an aws\_lambda\_permission's source\_arn attribute or in an aws\_iam\_policy to authorize access to the @connections API. |
| <a name="output_api_id"></a> [api\_id](#output\_api\_id) | The API identifier |
| <a name="output_api_mapping_id"></a> [api\_mapping\_id](#output\_api\_mapping\_id) | The API mapping identifier |
| <a name="output_apigatewayv2_authorizer_id"></a> [apigatewayv2\_authorizer\_id](#output\_apigatewayv2\_authorizer\_id) | The map of API Gateway Authorizer identifiers |
| <a name="output_domain_name_api_mapping_selection_expression"></a> [domain\_name\_api\_mapping\_selection\_expression](#output\_domain\_name\_api\_mapping\_selection\_expression) | The API mapping selection expression for the domain name |
| <a name="output_domain_name_arn"></a> [domain\_name\_arn](#output\_domain\_name\_arn) | The ARN of the domain name |
| <a name="output_domain_name_configuration"></a> [domain\_name\_configuration](#output\_domain\_name\_configuration) | The domain name configuration |
| <a name="output_domain_name_hosted_zone_id"></a> [domain\_name\_hosted\_zone\_id](#output\_domain\_name\_hosted\_zone\_id) | The Amazon Route 53 Hosted Zone ID of the endpoint |
| <a name="output_domain_name_id"></a> [domain\_name\_id](#output\_domain\_name\_id) | The domain name identifier |
| <a name="output_domain_name_target_domain_name"></a> [domain\_name\_target\_domain\_name](#output\_domain\_name\_target\_domain\_name) | The target domain name |
| <a name="output_integrations"></a> [integrations](#output\_integrations) | Map of the integrations created and their attributes |
| <a name="output_routes"></a> [routes](#output\_routes) | Map of the routes created and their attributes |
| <a name="output_stage_arn"></a> [stage\_arn](#output\_stage\_arn) | The stage ARN |
| <a name="output_stage_execution_arn"></a> [stage\_execution\_arn](#output\_stage\_execution\_arn) | The ARN prefix to be used in an aws\_lambda\_permission's source\_arn attribute or in an aws\_iam\_policy to authorize access to the @connections API. |
| <a name="output_stage_id"></a> [stage\_id](#output\_stage\_id) | The stage identifier |
| <a name="output_stage_invoke_url"></a> [stage\_invoke\_url](#output\_stage\_invoke\_url) | The URL to invoke the API pointing to the stage |
| <a name="output_vpc_links"></a> [vpc\_links](#output\_vpc\_links) | Map of VPC links created and their attributes |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
