# AWS API Gateway v2 (HTTP/Websocket) Terraform module

Terraform module which creates API Gateway version 2 with HTTP/Websocket capabilities.

These types of resources supported:

- [API Gateway](https://www.terraform.io/docs/providers/aws/r/apigatewayv2_api.html)
- [API Gateway Stage](https://www.terraform.io/docs/providers/aws/r/apigatewayv2_stage.html)
- [API Gateway Domain Name](https://www.terraform.io/docs/providers/aws/r/apigatewayv2_domain_name.html)
- [API Gateway API Mapping](https://www.terraform.io/docs/providers/aws/r/apigatewayv2_api_mapping.html)
- [API Gateway Route](https://www.terraform.io/docs/providers/aws/r/apigatewayv2_route.html)
- [API Gateway Integration](https://www.terraform.io/docs/providers/aws/r/apigatewayv2_integration.html)
- [API Gateway VPC Link](https://www.terraform.io/docs/providers/aws/r/apigatewayv2_vpc_link.html)

Not supported, yet:

- [API Gateway Authorizer](https://www.terraform.io/docs/providers/aws/r/apigatewayv2_authorizer.html)
- [API Gateway Deployment](https://www.terraform.io/docs/providers/aws/r/apigatewayv2_deployment.html)
- [API Gateway Model](https://www.terraform.io/docs/providers/aws/r/apigatewayv2_model.html)
- [API Gateway Route Response](https://www.terraform.io/docs/providers/aws/r/apigatewayv2_route_response.html)
- [API Gateway Integration Response](https://www.terraform.io/docs/providers/aws/r/apigatewayv2_integration_response.html)

This Terraform module is part of [serverless.tf framework](https://serverless.tf), which aims to simplify all operations when working with the serverless in Terraform.

## Features

- [x] Support many of features of HTTP API Gateway, but rather limited support for WebSocket API Gateway
- [x] Conditional creation for many types of resources
- [ ] Some features are still missing (especially for WebSocket support)

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

- [Complete HTTP](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/tree/master/examples/complete-http) - Create API Gateway, domain name, stage and other resources in various combinations
- [HTTP with VPC Link](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/tree/master/examples/vpc-link-http) - Create API Gateway with VPC link to access private resources

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.6, < 0.14 |
| aws | >= 2.59, < 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.59, < 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| api\_key\_selection\_expression | An API key selection expression. Valid values: $context.authorizer.usageIdentifierKey, $request.header.x-api-key. | `string` | `"$request.header.x-api-key"` | no |
| api\_version | A version identifier for the API | `string` | `null` | no |
| cors\_configuration | The cross-origin resource sharing (CORS) configuration. Applicable for HTTP APIs. | `any` | `{}` | no |
| create | Controls if API Gateway resources should be created | `bool` | `true` | no |
| create\_api\_domain\_name | Whether to create API domain name resource | `bool` | `true` | no |
| create\_api\_gateway | Whether to create API Gateway | `bool` | `true` | no |
| create\_default\_stage | Whether to create default stage | `bool` | `true` | no |
| create\_default\_stage\_api\_mapping | Whether to create default stage API mapping | `bool` | `true` | no |
| create\_routes\_and\_integrations | Whether to create routes and integrations resources | `bool` | `true` | no |
| create\_vpc\_link | Whether to create VPC link resource | `bool` | `false` | no |
| credentials\_arn | Part of quick create. Specifies any credentials required for the integration. Applicable for HTTP APIs. | `string` | `null` | no |
| default\_stage\_access\_log\_destination\_arn | Default stage's ARN of the CloudWatch Logs log group to receive access logs. Any trailing :\* is trimmed from the ARN. | `string` | `null` | no |
| default\_stage\_access\_log\_format | Default stage's single line format of the access logs of data, as specified by selected $context variables. | `string` | `null` | no |
| default\_stage\_tags | A mapping of tags to assign to the default stage resource. | `map(string)` | `{}` | no |
| description | The description of the API. | `string` | `null` | no |
| domain\_name | The domain name to use for API gateway | `string` | `null` | no |
| domain\_name\_certificate\_arn | The ARN of an AWS-managed certificate that will be used by the endpoint for the domain name | `string` | `null` | no |
| domain\_name\_tags | A mapping of tags to assign to API domain name resource. | `map(string)` | `{}` | no |
| integrations | Map of API gateway routes with integrations | `map(any)` | `{}` | no |
| name | The name of the API | `string` | `""` | no |
| protocol\_type | The API protocol. Valid values: HTTP, WEBSOCKET | `string` | `"HTTP"` | no |
| route\_key | Part of quick create. Specifies any route key. Applicable for HTTP APIs. | `string` | `null` | no |
| route\_selection\_expression | The route selection expression for the API. | `string` | `"$request.method $request.path"` | no |
| security\_group\_ids | Security group IDs for the VPC Link | `list(string)` | `[]` | no |
| subnet\_ids | Subnet IDs for the VPC Link | `list(string)` | `[]` | no |
| tags | A mapping of tags to assign to API gateway resources. | `map(string)` | `{}` | no |
| target | Part of quick create. Quick create produces an API with an integration, a default catch-all route, and a default stage which is configured to automatically deploy changes. For HTTP integrations, specify a fully qualified URL. For Lambda integrations, specify a function ARN. The type of the integration will be HTTP\_PROXY or AWS\_PROXY, respectively. Applicable for HTTP APIs. | `string` | `null` | no |
| vpc\_link\_tags | A map of tags to add to the VPC Link | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| default\_apigatewayv2\_stage\_arn | The default stage ARN |
| default\_apigatewayv2\_stage\_execution\_arn | The ARN prefix to be used in an aws\_lambda\_permission's source\_arn attribute or in an aws\_iam\_policy to authorize access to the @connections API. |
| default\_apigatewayv2\_stage\_id | The default stage identifier |
| default\_apigatewayv2\_stage\_invoke\_url | The URL to invoke the API pointing to the stage |
| this\_apigatewayv2\_api\_api\_endpoint | The URI of the API |
| this\_apigatewayv2\_api\_arn | The ARN of the API |
| this\_apigatewayv2\_api\_execution\_arn | The ARN prefix to be used in an aws\_lambda\_permission's source\_arn attribute or in an aws\_iam\_policy to authorize access to the @connections API. |
| this\_apigatewayv2\_api\_id | The API identifier |
| this\_apigatewayv2\_api\_mapping\_id | The API mapping identifier. |
| this\_apigatewayv2\_domain\_name\_api\_mapping\_selection\_expression | The API mapping selection expression for the domain name. |
| this\_apigatewayv2\_domain\_name\_arn | The ARN of the domain name |
| this\_apigatewayv2\_domain\_name\_configuration | The ARN of the domain name |
| this\_apigatewayv2\_domain\_name\_id | The domain name identifier |
| this\_apigatewayv2\_vpc\_link\_arn | The VPC Link ARN |
| this\_apigatewayv2\_vpc\_link\_id | The VPC Link identifier |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Authors

Module managed by [Anton Babenko](https://github.com/antonbabenko). Check out [serverless.tf](https://serverless.tf) to learn more about doing serverless with Terraform.

Please reach out to [Betajob](https://www.betajob.com/) if you are looking for commercial support for your Terraform, AWS, or serverless project.

## License

Apache 2 Licensed. See LICENSE for full details.
