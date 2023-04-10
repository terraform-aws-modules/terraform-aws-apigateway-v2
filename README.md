# AWS API Gateway v2 (HTTP/Websocket) Terraform module

Terraform module which creates API Gateway v2 resources with HTTP/Websocket capabilities.

This Terraform module is part of [serverless.tf framework](https://serverless.tf), which aims to simplify all operations when working with the serverless in Terraform.

## Supported Features

- Conditional creation
- VPC Links
- HTTP API
- Websocket API

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
  stage_access_log_destination_arn = "arn:aws:logs:eu-west-1:835367859851:log-group:debug-apigateway"
  stage_access_log_format          = "$context.identity.sourceIp - - [$context.requestTime] \"$context.httpMethod $context.routeKey $context.protocol\" $context.status $context.responseLength $context.requestId $context.integrationErrorMessage"

  # Routes and integrations
  integrations = {
    "POST /" = {
      lambda_arn             = "arn:aws:lambda:eu-west-1:052235179155:function:my-function"
      payload_format_version = "2.0"
      timeout_milliseconds   = 12000
    }

    "GET /some-route-with-authorizer" = {
      integration_type = "HTTP_PROXY"
      integration_uri  = "some url"
      authorizer_key   = "azure"
    }

    "$default" = {
      lambda_arn = "arn:aws:lambda:eu-west-1:052235179155:function:my-default-function"
    }
  }

  authorizers = {
    "azure" = {
      authorizer_type  = "JWT"
      identity_sources = "$request.header.Authorization"
      name             = "azure-auth"
      audience         = ["d6a38afd-45d6-4874-d1aa-3c5c558aqcc2"]
      issuer           = "https://sts.windows.net/aaee026e-8f37-410e-8869-72d9154873e4/"
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

  # Disable creation of the API and all resources
  create = false

  # Disable creation of the domain name and API mapping
  create_api_domain_name = false

  # Disable creation of the stage
  create_stage = false

  # Disable creation of the routes and integrations
  create_routes_and_integrations = false

  # Disable creation of the VPC link
  create_vpc_link = false

  # ... omitted
}
```

## Examples

- [Complete HTTP](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/tree/master/examples/complete-http) - Create API Gateway, authorizer, domain name, stage and other resources in various combinations
- [HTTP with VPC Link](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/tree/master/examples/vpc-link-http) - Create API Gateway with VPC link and integration with resources in VPC (eg. ALB)
- [Websocket](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/tree/master/examples/websocket) - Create Websocket API

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_api_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api_mapping) | resource |
| [aws_apigatewayv2_authorizer.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_authorizer) | resource |
| [aws_apigatewayv2_domain_name.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_domain_name) | resource |
| [aws_apigatewayv2_integration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_integration_response.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration_response) | resource |
| [aws_apigatewayv2_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_apigatewayv2_stage.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage) | resource |
| [aws_apigatewayv2_vpc_link.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_vpc_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key_selection_expression"></a> [api\_key\_selection\_expression](#input\_api\_key\_selection\_expression) | An API key selection expression. Valid values: `$context.authorizer.usageIdentifierKey`, `$request.header.x-api-key`. Defaults to `$request.header.x-api-key`. Applicable for WebSocket APIs | `string` | `null` | no |
| <a name="input_api_mapping_key"></a> [api\_mapping\_key](#input\_api\_mapping\_key) | The [API mapping key](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api-mapping-template-reference.html) | `string` | `null` | no |
| <a name="input_api_version"></a> [api\_version](#input\_api\_version) | A version identifier for the API. Must be between 1 and 64 characters in length | `string` | `null` | no |
| <a name="input_authorizers"></a> [authorizers](#input\_authorizers) | Map of API gateway authorizers to create | `any` | `{}` | no |
| <a name="input_body"></a> [body](#input\_body) | An OpenAPI specification that defines the set of routes and integrations to create as part of the HTTP APIs. Supported only for HTTP APIs | `string` | `null` | no |
| <a name="input_cors_configuration"></a> [cors\_configuration](#input\_cors\_configuration) | The cross-origin resource sharing (CORS) configuration. Applicable for HTTP APIs | `any` | `{}` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created | `bool` | `true` | no |
| <a name="input_create_domain_name"></a> [create\_domain\_name](#input\_create\_domain\_name) | Whether to create API domain name resource | `bool` | `false` | no |
| <a name="input_create_routes_and_integrations"></a> [create\_routes\_and\_integrations](#input\_create\_routes\_and\_integrations) | Whether to create routes and integrations resources | `bool` | `true` | no |
| <a name="input_create_stage"></a> [create\_stage](#input\_create\_stage) | Whether to create default stage | `bool` | `true` | no |
| <a name="input_credentials_arn"></a> [credentials\_arn](#input\_credentials\_arn) | Part of quick create. Specifies any credentials required for the integration. Applicable for HTTP APIs | `string` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the API. Must be less than or equal to 1024 characters in length | `string` | `null` | no |
| <a name="input_disable_execute_api_endpoint"></a> [disable\_execute\_api\_endpoint](#input\_disable\_execute\_api\_endpoint) | Whether clients can invoke the API by using the default execute-api endpoint. By default, clients can invoke the API with the default `{api_id}.execute-api.{region}.amazonaws.com endpoint`. To require that clients use a custom domain name to invoke the API, disable the default endpoint | `bool` | `null` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name to use for API gateway | `string` | `null` | no |
| <a name="input_domain_name_certificate_arn"></a> [domain\_name\_certificate\_arn](#input\_domain\_name\_certificate\_arn) | The ARN of an AWS-managed certificate that will be used by the endpoint for the domain name. AWS Certificate Manager is the only supported source | `string` | `null` | no |
| <a name="input_domain_name_ownership_verification_certificate_arn"></a> [domain\_name\_ownership\_verification\_certificate\_arn](#input\_domain\_name\_ownership\_verification\_certificate\_arn) | ARN of the AWS-issued certificate used to validate custom domain ownership (when certificate\_arn is issued via an ACM Private CA or mutual\_tls\_authentication is configured with an ACM-imported certificate.) | `string` | `null` | no |
| <a name="input_fail_on_warnings"></a> [fail\_on\_warnings](#input\_fail\_on\_warnings) | Whether warnings should return an error while API Gateway is creating or updating the resource using an OpenAPI specification. Defaults to `false`. Applicable for HTTP APIs | `bool` | `null` | no |
| <a name="input_integrations"></a> [integrations](#input\_integrations) | Map of API gateway routes with integrations | `any` | `{}` | no |
| <a name="input_mutual_tls_authentication"></a> [mutual\_tls\_authentication](#input\_mutual\_tls\_authentication) | The mutual TLS authentication configuration for the domain name | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the API. Must be less than or equal to 128 characters in length | `string` | `""` | no |
| <a name="input_protocol_type"></a> [protocol\_type](#input\_protocol\_type) | The API protocol. Valid values: `HTTP`, `WEBSOCKET` | `string` | `"HTTP"` | no |
| <a name="input_route_key"></a> [route\_key](#input\_route\_key) | Part of quick create. Specifies any route key. Applicable for HTTP APIs | `string` | `null` | no |
| <a name="input_route_selection_expression"></a> [route\_selection\_expression](#input\_route\_selection\_expression) | The route selection expression for the API. Defaults to `$request.method $request.path` | `string` | `null` | no |
| <a name="input_stage_access_log_settings"></a> [stage\_access\_log\_settings](#input\_stage\_access\_log\_settings) | Settings for logging access in this stage. Use the aws\_api\_gateway\_account resource to configure [permissions for CloudWatch Logging](https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html#set-up-access-logging-permissions) | `map(string)` | `{}` | no |
| <a name="input_stage_client_certificate_id"></a> [stage\_client\_certificate\_id](#input\_stage\_client\_certificate\_id) | The identifier of a client certificate for the stage. Use the `aws_api_gateway_client_certificate` resource to configure a client certificate. Supported only for WebSocket APIs | `string` | `null` | no |
| <a name="input_stage_default_route_settings"></a> [stage\_default\_route\_settings](#input\_stage\_default\_route\_settings) | The default route settings for the stage | `map(string)` | `{}` | no |
| <a name="input_stage_description"></a> [stage\_description](#input\_stage\_description) | The description for the stage. Must be less than or equal to 1024 characters in length | `string` | `null` | no |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | The name of the stage. Must be between 1 and 128 characters in length | `string` | `"$default"` | no |
| <a name="input_stage_tags"></a> [stage\_tags](#input\_stage\_tags) | A mapping of tags to assign to the stage resource | `map(string)` | `{}` | no |
| <a name="input_stage_variables"></a> [stage\_variables](#input\_stage\_variables) | A map that defines the stage variables for the stage | `map(string)` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to API gateway resources | `map(string)` | `{}` | no |
| <a name="input_target"></a> [target](#input\_target) | Part of quick create. Quick create produces an API with an integration, a default catch-all route, and a default stage which is configured to automatically deploy changes. For HTTP integrations, specify a fully qualified URL. For Lambda integrations, specify a function ARN. The type of the integration will be HTTP\_PROXY or AWS\_PROXY, respectively. Applicable for HTTP APIs | `string` | `null` | no |
| <a name="input_vpc_link_tags"></a> [vpc\_link\_tags](#input\_vpc\_link\_tags) | A map of tags to add to the VPC Links created | `map(string)` | `{}` | no |
| <a name="input_vpc_links"></a> [vpc\_links](#input\_vpc\_links) | Map of VPC Link definitions to create | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
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
| <a name="output_stage_arn"></a> [stage\_arn](#output\_stage\_arn) | The stage ARN |
| <a name="output_stage_execution_arn"></a> [stage\_execution\_arn](#output\_stage\_execution\_arn) | The ARN prefix to be used in an aws\_lambda\_permission's source\_arn attribute or in an aws\_iam\_policy to authorize access to the @connections API |
| <a name="output_stage_id"></a> [stage\_id](#output\_stage\_id) | The stage identifier |
| <a name="output_stage_invoke_url"></a> [stage\_invoke\_url](#output\_stage\_invoke\_url) | The URL to invoke the API pointing to the stage |
| <a name="output_vpc_links"></a> [vpc\_links](#output\_vpc\_links) | Map of VPC links created and their attributes |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Anton Babenko](https://github.com/antonbabenko). Check out [serverless.tf](https://serverless.tf) to learn more about doing serverless with Terraform.

Please reach out to [Betajob](https://www.betajob.com/) if you are looking for commercial support for your Terraform, AWS, or serverless project.

## License

Apache 2 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/tree/master/LICENSE) for full details.
