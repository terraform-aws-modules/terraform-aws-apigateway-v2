# AWS API Gateway v2 (HTTP/Websocket) Terraform module

Terraform module which creates API Gateway version 2 with HTTP/Websocket capabilities.

This Terraform module is part of [serverless.tf framework](https://serverless.tf), which aims to simplify all operations when working with the serverless in Terraform.

## Supported Features

- Support many of features of HTTP API Gateway, but rather limited support for WebSocket API Gateway
- Conditional creation for many types of resources

## Feature Roadmap

- Some features are still missing (especially for WebSocket support)

## Usage

### HTTP API Gateway

```hcl
module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  name          = "dev-http"
  description   = "My awesome HTTP API Gateway"
  protocol_type = "HTTP"

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  # Custom domain
  domain_name                 = "terraform-aws-modules.modules.tf"
  domain_name_certificate_arn = "arn:aws:acm:eu-west-1:052235179155:certificate/2b3a7ed9-05e1-4f9e-952b-27744ba06da6"

  # Access logs
  default_stage_access_log_destination_arn = "arn:aws:logs:eu-west-1:835367859851:log-group:debug-apigateway"
  default_stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  # Routes and integrations
  integrations = {
    "POST /" = {
      lambda_arn             = "arn:aws:lambda:eu-west-1:052235179155:function:my-function"
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }

    "$default" = {
      lambda_arn = "arn:aws:lambda:eu-west-1:052235179155:function:my-default-function"
    }
  }

  tags = {
    Name = "http-apigateway"
  }
}
```

## Conditional creation

Sometimes you need to have a way to create resources conditionally but Terraform does not allow usage of `count` inside `module` block, so the solution is to specify `create` arguments.

```hcl
module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  create = false # to disable all resources

  create_api_gateway               = false  # to control creation of API Gateway
  create_api_domain_name           = false  # to control creation of API Gateway Domain Name
  create_default_stage             = false  # to control creation of "$default" stage
  create_default_stage_api_mapping = false  # to control creation of "$default" stage and API mapping
  create_routes_and_integrations   = false  # to control creation of routes and integrations
  create_vpc_link                  = false  # to control creation of VPC link

  # ... omitted
}
```

## Notes:

- Make sure provider block has the setting of `skip_requesting_account_id` disabled (`false`) to produce correct value in the `execution_arn`.

## Examples

- [Complete HTTP](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/tree/master/examples/complete-http) - Create API Gateway, authorizer, domain name, stage and other resources in various combinations
- [HTTP with VPC Link](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/tree/master/examples/vpc-link-http) - Create API Gateway with VPC link and integration with resources in VPC (eg. ALB)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.26 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_api_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api_mapping) | resource |
| [aws_apigatewayv2_domain_name.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_domain_name) | resource |
| [aws_apigatewayv2_integration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_apigatewayv2_stage.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage) | resource |
| [aws_apigatewayv2_vpc_link.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_vpc_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key_selection_expression"></a> [api\_key\_selection\_expression](#input\_api\_key\_selection\_expression) | An API key selection expression. Valid values: $context.authorizer.usageIdentifierKey, $request.header.x-api-key. | `string` | `"$request.header.x-api-key"` | no |
| <a name="input_api_version"></a> [api\_version](#input\_api\_version) | A version identifier for the API | `string` | `null` | no |
| <a name="input_body"></a> [body](#input\_body) | An OpenAPI specification that defines the set of routes and integrations to create as part of the HTTP APIs. Supported only for HTTP APIs. | `string` | `null` | no |
| <a name="input_cors_configuration"></a> [cors\_configuration](#input\_cors\_configuration) | The cross-origin resource sharing (CORS) configuration. Applicable for HTTP APIs. | `any` | `{}` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if API Gateway resources should be created | `bool` | `true` | no |
| <a name="input_create_api_domain_name"></a> [create\_api\_domain\_name](#input\_create\_api\_domain\_name) | Whether to create API domain name resource | `bool` | `true` | no |
| <a name="input_create_api_gateway"></a> [create\_api\_gateway](#input\_create\_api\_gateway) | Whether to create API Gateway | `bool` | `true` | no |
| <a name="input_create_default_stage"></a> [create\_default\_stage](#input\_create\_default\_stage) | Whether to create default stage | `bool` | `true` | no |
| <a name="input_create_default_stage_api_mapping"></a> [create\_default\_stage\_api\_mapping](#input\_create\_default\_stage\_api\_mapping) | Whether to create default stage API mapping | `bool` | `true` | no |
| <a name="input_create_routes_and_integrations"></a> [create\_routes\_and\_integrations](#input\_create\_routes\_and\_integrations) | Whether to create routes and integrations resources | `bool` | `true` | no |
| <a name="input_create_vpc_link"></a> [create\_vpc\_link](#input\_create\_vpc\_link) | Whether to create VPC links | `bool` | `true` | no |
| <a name="input_credentials_arn"></a> [credentials\_arn](#input\_credentials\_arn) | Part of quick create. Specifies any credentials required for the integration. Applicable for HTTP APIs. | `string` | `null` | no |
| <a name="input_default_route_settings"></a> [default\_route\_settings](#input\_default\_route\_settings) | Settings for default route | `map(string)` | `{}` | no |
| <a name="input_default_stage_access_log_destination_arn"></a> [default\_stage\_access\_log\_destination\_arn](#input\_default\_stage\_access\_log\_destination\_arn) | Default stage's ARN of the CloudWatch Logs log group to receive access logs. Any trailing :* is trimmed from the ARN. | `string` | `null` | no |
| <a name="input_default_stage_access_log_format"></a> [default\_stage\_access\_log\_format](#input\_default\_stage\_access\_log\_format) | Default stage's single line format of the access logs of data, as specified by selected $context variables. | `string` | `null` | no |
| <a name="input_default_stage_tags"></a> [default\_stage\_tags](#input\_default\_stage\_tags) | A mapping of tags to assign to the default stage resource. | `map(string)` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the API. | `string` | `null` | no |
| <a name="input_disable_execute_api_endpoint"></a> [disable\_execute\_api\_endpoint](#input\_disable\_execute\_api\_endpoint) | Whether clients can invoke the API by using the default execute-api endpoint. To require that clients use a custom domain name to invoke the API, disable the default endpoint | `string` | `false` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name to use for API gateway | `string` | `null` | no |
| <a name="input_domain_name_certificate_arn"></a> [domain\_name\_certificate\_arn](#input\_domain\_name\_certificate\_arn) | The ARN of an AWS-managed certificate that will be used by the endpoint for the domain name | `string` | `null` | no |
| <a name="input_domain_name_tags"></a> [domain\_name\_tags](#input\_domain\_name\_tags) | A mapping of tags to assign to API domain name resource. | `map(string)` | `{}` | no |
| <a name="input_integrations"></a> [integrations](#input\_integrations) | Map of API gateway routes with integrations | `map(any)` | `{}` | no |
| <a name="input_mutual_tls_authentication"></a> [mutual\_tls\_authentication](#input\_mutual\_tls\_authentication) | An Amazon S3 URL that specifies the truststore for mutual TLS authentication as well as version, keyed at uri and version | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the API | `string` | `""` | no |
| <a name="input_protocol_type"></a> [protocol\_type](#input\_protocol\_type) | The API protocol. Valid values: HTTP, WEBSOCKET | `string` | `"HTTP"` | no |
| <a name="input_route_key"></a> [route\_key](#input\_route\_key) | Part of quick create. Specifies any route key. Applicable for HTTP APIs. | `string` | `null` | no |
| <a name="input_route_selection_expression"></a> [route\_selection\_expression](#input\_route\_selection\_expression) | The route selection expression for the API. | `string` | `"$request.method $request.path"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to API gateway resources. | `map(string)` | `{}` | no |
| <a name="input_target"></a> [target](#input\_target) | Part of quick create. Quick create produces an API with an integration, a default catch-all route, and a default stage which is configured to automatically deploy changes. For HTTP integrations, specify a fully qualified URL. For Lambda integrations, specify a function ARN. The type of the integration will be HTTP\_PROXY or AWS\_PROXY, respectively. Applicable for HTTP APIs. | `string` | `null` | no |
| <a name="input_vpc_link_tags"></a> [vpc\_link\_tags](#input\_vpc\_link\_tags) | A map of tags to add to the VPC Link | `map(string)` | `{}` | no |
| <a name="input_vpc_links"></a> [vpc\_links](#input\_vpc\_links) | Map of VPC Links details to create | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_apigatewayv2_api_api_endpoint"></a> [apigatewayv2\_api\_api\_endpoint](#output\_apigatewayv2\_api\_api\_endpoint) | The URI of the API |
| <a name="output_apigatewayv2_api_arn"></a> [apigatewayv2\_api\_arn](#output\_apigatewayv2\_api\_arn) | The ARN of the API |
| <a name="output_apigatewayv2_api_execution_arn"></a> [apigatewayv2\_api\_execution\_arn](#output\_apigatewayv2\_api\_execution\_arn) | The ARN prefix to be used in an aws\_lambda\_permission's source\_arn attribute or in an aws\_iam\_policy to authorize access to the @connections API. |
| <a name="output_apigatewayv2_api_id"></a> [apigatewayv2\_api\_id](#output\_apigatewayv2\_api\_id) | The API identifier |
| <a name="output_apigatewayv2_api_mapping_id"></a> [apigatewayv2\_api\_mapping\_id](#output\_apigatewayv2\_api\_mapping\_id) | The API mapping identifier. |
| <a name="output_apigatewayv2_domain_name_api_mapping_selection_expression"></a> [apigatewayv2\_domain\_name\_api\_mapping\_selection\_expression](#output\_apigatewayv2\_domain\_name\_api\_mapping\_selection\_expression) | The API mapping selection expression for the domain name |
| <a name="output_apigatewayv2_domain_name_arn"></a> [apigatewayv2\_domain\_name\_arn](#output\_apigatewayv2\_domain\_name\_arn) | The ARN of the domain name |
| <a name="output_apigatewayv2_domain_name_configuration"></a> [apigatewayv2\_domain\_name\_configuration](#output\_apigatewayv2\_domain\_name\_configuration) | The domain name configuration |
| <a name="output_apigatewayv2_domain_name_hosted_zone_id"></a> [apigatewayv2\_domain\_name\_hosted\_zone\_id](#output\_apigatewayv2\_domain\_name\_hosted\_zone\_id) | The Amazon Route 53 Hosted Zone ID of the endpoint |
| <a name="output_apigatewayv2_domain_name_id"></a> [apigatewayv2\_domain\_name\_id](#output\_apigatewayv2\_domain\_name\_id) | The domain name identifier |
| <a name="output_apigatewayv2_domain_name_target_domain_name"></a> [apigatewayv2\_domain\_name\_target\_domain\_name](#output\_apigatewayv2\_domain\_name\_target\_domain\_name) | The target domain name |
| <a name="output_apigatewayv2_vpc_link_arn"></a> [apigatewayv2\_vpc\_link\_arn](#output\_apigatewayv2\_vpc\_link\_arn) | The map of VPC Link ARNs |
| <a name="output_apigatewayv2_vpc_link_id"></a> [apigatewayv2\_vpc\_link\_id](#output\_apigatewayv2\_vpc\_link\_id) | The map of VPC Link identifiers |
| <a name="output_default_apigatewayv2_stage_arn"></a> [default\_apigatewayv2\_stage\_arn](#output\_default\_apigatewayv2\_stage\_arn) | The default stage ARN |
| <a name="output_default_apigatewayv2_stage_domain_name"></a> [default\_apigatewayv2\_stage\_domain\_name](#output\_default\_apigatewayv2\_stage\_domain\_name) | Domain name of the stage (useful for CloudFront distribution) |
| <a name="output_default_apigatewayv2_stage_execution_arn"></a> [default\_apigatewayv2\_stage\_execution\_arn](#output\_default\_apigatewayv2\_stage\_execution\_arn) | The ARN prefix to be used in an aws\_lambda\_permission's source\_arn attribute or in an aws\_iam\_policy to authorize access to the @connections API. |
| <a name="output_default_apigatewayv2_stage_id"></a> [default\_apigatewayv2\_stage\_id](#output\_default\_apigatewayv2\_stage\_id) | The default stage identifier |
| <a name="output_default_apigatewayv2_stage_invoke_url"></a> [default\_apigatewayv2\_stage\_invoke\_url](#output\_default\_apigatewayv2\_stage\_invoke\_url) | The URL to invoke the API pointing to the stage |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Anton Babenko](https://github.com/antonbabenko). Check out [serverless.tf](https://serverless.tf) to learn more about doing serverless with Terraform.

Please reach out to [Betajob](https://www.betajob.com/) if you are looking for commercial support for your Terraform, AWS, or serverless project.

## License

Apache 2 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/tree/master/LICENSE) for full details.
