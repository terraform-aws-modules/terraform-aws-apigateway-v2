# AWS API Gateway v2 (HTTP/Websocket) Terraform module

Terraform module which creates API Gateway v2 resources with HTTP/Websocket capabilities.

This Terraform module is part of [serverless.tf framework](https://serverless.tf), which aims to simplify all operations when working with the serverless in Terraform.

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
  domain_name = "terraform-aws-modules.modules.tf"

  # Access logs
  stage_access_log_settings = {
    create_log_group            = true
    log_group_retention_in_days = 7
    format = jsonencode({
      context = {
        domainName              = "$context.domainName"
        integrationErrorMessage = "$context.integrationErrorMessage"
        protocol                = "$context.protocol"
        requestId               = "$context.requestId"
        requestTime             = "$context.requestTime"
        responseLength          = "$context.responseLength"
        routeKey                = "$context.routeKey"
        stage                   = "$context.stage"
        status                  = "$context.status"
        error = {
          message      = "$context.error.message"
          responseType = "$context.error.responseType"
        }
        identity = {
          sourceIP = "$context.identity.sourceIp"
        }
        integration = {
          error             = "$context.integration.error"
          integrationStatus = "$context.integration.integrationStatus"
        }
      }
    })
  }

  # Authorizer(s)
  authorizers = {
    "azure" = {
      authorizer_type  = "JWT"
      identity_sources = ["$request.header.Authorization"]
      name             = "azure-auth"
      jwt_configuration = {
        audience         = ["d6a38afd-45d6-4874-d1aa-3c5c558aqcc2"]
        issuer           = "https://sts.windows.net/aaee026e-8f37-410e-8869-72d9154873e4/"
      }
    }
  }

  # Routes & Integration(s)
  routes = {
    "POST /" = {
      integration = {
        uri                    = "arn:aws:lambda:eu-west-1:052235179155:function:my-function"
        payload_format_version = "2.0"
        timeout_milliseconds   = 12000
      }
    }

    "GET /some-route-with-authorizer" = {
      authorizer_key = "azure"

      integration = {
        type = "HTTP_PROXY"
        uri  = "some url"
      }
    }

    "$default" = {
      integration = {
        uri = "arn:aws:lambda:eu-west-1:052235179155:function:my-default-function"
      }
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
```

## Multiple Subdomains

API Gateway v2 supports wildcard custom domains which allow users to map multiple subdomains to the same API Gateway. This is useful when you have multiple customers and you want to provide them with a custom domain for their API endpoint and possibly use that for header based routing/rules.

```hcl
module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  ...
  domain_name = "*.mydomain.com"
  subdomains  = ["customer1", "customer2"]
  ...
}
```

This will create records that allow users to access the API Gateway using the following subdomains:
- `customer1.mydomain.com`
- `customer2.mydomain.com`

## Specific Hosted Zone

If you want to create the domain name in a specific hosted zone, you can use the `hosted_zone_name` input parameter:

```hcl
module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  ...
  hosted_zone_name = "api.mydomain.com"
  domain_name      = "prod.api.mydomain.com"
  ...
}
```

## Conditional Creation

The following values are provided to toggle on/off creation of the associated resources as desired:

```hcl
module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"

  # Disable creation of the API and all resources
  create = false

  # Disable creation of the domain name and API mapping
  create_domain_name = false

  # Disable creation of Route53 alias record(s) for the custom domain
  create_domain_records = false

  # Disable creation of the ACM certificate for the custom domain
  create_certificate = false

  # Disable creation of the routes and integrations
  create_routes_and_integrations = false

  # Disable creation of the stage
  create_stage = false

  # ... omitted
}
```

## Examples

- [Complete HTTP](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/tree/master/examples/complete-http) - Create API Gateway, authorizer, domain name, stage and other resources in various combinations
- [HTTP with VPC Link](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/tree/master/examples/vpc-link-http) - Create API Gateway with VPC link and integration with resources in VPC (eg. ALB)
- [Websocket](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/tree/master/examples/websocket) - Create Websocket API

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.96 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.96 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_acm"></a> [acm](#module\_acm) | terraform-aws-modules/acm/aws | 5.0.1 |

## Resources

| Name | Type |
|------|------|
| [aws_apigatewayv2_api.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api) | resource |
| [aws_apigatewayv2_api_mapping.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api_mapping) | resource |
| [aws_apigatewayv2_authorizer.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_authorizer) | resource |
| [aws_apigatewayv2_deployment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_deployment) | resource |
| [aws_apigatewayv2_domain_name.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_domain_name) | resource |
| [aws_apigatewayv2_integration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration) | resource |
| [aws_apigatewayv2_integration_response.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_integration_response) | resource |
| [aws_apigatewayv2_route.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route) | resource |
| [aws_apigatewayv2_route_response.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_route_response) | resource |
| [aws_apigatewayv2_stage.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_stage) | resource |
| [aws_apigatewayv2_vpc_link.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_vpc_link) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_route53_record.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key_selection_expression"></a> [api\_key\_selection\_expression](#input\_api\_key\_selection\_expression) | An API key selection expression. Valid values: `$context.authorizer.usageIdentifierKey`, `$request.header.x-api-key`. Defaults to `$request.header.x-api-key`. Applicable for WebSocket APIs | `string` | `null` | no |
| <a name="input_api_mapping_key"></a> [api\_mapping\_key](#input\_api\_mapping\_key) | The [API mapping key](https://docs.aws.amazon.com/apigateway/latest/developerguide/apigateway-websocket-api-mapping-template-reference.html) | `string` | `null` | no |
| <a name="input_api_version"></a> [api\_version](#input\_api\_version) | A version identifier for the API. Must be between 1 and 64 characters in length | `string` | `null` | no |
| <a name="input_authorizers"></a> [authorizers](#input\_authorizers) | Map of API gateway authorizers to create | <pre>map(object({<br/>    authorizer_credentials_arn        = optional(string)<br/>    authorizer_payload_format_version = optional(string)<br/>    authorizer_result_ttl_in_seconds  = optional(number)<br/>    authorizer_type                   = optional(string, "REQUEST")<br/>    authorizer_uri                    = optional(string)<br/>    enable_simple_responses           = optional(bool)<br/>    identity_sources                  = optional(list(string))<br/>    jwt_configuration = optional(object({<br/>      audience = optional(list(string))<br/>      issuer   = optional(string)<br/>    }))<br/>    name = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_body"></a> [body](#input\_body) | An OpenAPI specification that defines the set of routes and integrations to create as part of the HTTP APIs. Supported only for HTTP APIs | `string` | `null` | no |
| <a name="input_cors_configuration"></a> [cors\_configuration](#input\_cors\_configuration) | The cross-origin resource sharing (CORS) configuration. Applicable for HTTP APIs | <pre>object({<br/>    allow_credentials = optional(bool)<br/>    allow_headers     = optional(list(string))<br/>    allow_methods     = optional(list(string))<br/>    allow_origins     = optional(list(string))<br/>    expose_headers    = optional(list(string), [])<br/>    max_age           = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_create"></a> [create](#input\_create) | Controls if resources should be created | `bool` | `true` | no |
| <a name="input_create_certificate"></a> [create\_certificate](#input\_create\_certificate) | Whether to create a certificate for the domain | `bool` | `true` | no |
| <a name="input_create_domain_name"></a> [create\_domain\_name](#input\_create\_domain\_name) | Whether to create API domain name resource | `bool` | `true` | no |
| <a name="input_create_domain_records"></a> [create\_domain\_records](#input\_create\_domain\_records) | Whether to create Route53 records for the domain name | `bool` | `true` | no |
| <a name="input_create_routes_and_integrations"></a> [create\_routes\_and\_integrations](#input\_create\_routes\_and\_integrations) | Whether to create routes and integrations resources | `bool` | `true` | no |
| <a name="input_create_stage"></a> [create\_stage](#input\_create\_stage) | Whether to create default stage | `bool` | `true` | no |
| <a name="input_credentials_arn"></a> [credentials\_arn](#input\_credentials\_arn) | Part of quick create. Specifies any credentials required for the integration. Applicable for HTTP APIs | `string` | `null` | no |
| <a name="input_deploy_stage"></a> [deploy\_stage](#input\_deploy\_stage) | Whether to deploy the stage. `HTTP` APIs are auto-deployed by default | `bool` | `true` | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the API. Must be less than or equal to 1024 characters in length | `string` | `null` | no |
| <a name="input_disable_execute_api_endpoint"></a> [disable\_execute\_api\_endpoint](#input\_disable\_execute\_api\_endpoint) | Whether clients can invoke the API by using the default execute-api endpoint. By default, clients can invoke the API with the default `{api_id}.execute-api.{region}.amazonaws.com endpoint`. To require that clients use a custom domain name to invoke the API, disable the default endpoint | `bool` | `null` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | The domain name to use for API gateway | `string` | `""` | no |
| <a name="input_domain_name_certificate_arn"></a> [domain\_name\_certificate\_arn](#input\_domain\_name\_certificate\_arn) | The ARN of an AWS-managed certificate that will be used by the endpoint for the domain name. AWS Certificate Manager is the only supported source | `string` | `null` | no |
| <a name="input_domain_name_ownership_verification_certificate_arn"></a> [domain\_name\_ownership\_verification\_certificate\_arn](#input\_domain\_name\_ownership\_verification\_certificate\_arn) | ARN of the AWS-issued certificate used to validate custom domain ownership (when certificate\_arn is issued via an ACM Private CA or mutual\_tls\_authentication is configured with an ACM-imported certificate.) | `string` | `null` | no |
| <a name="input_fail_on_warnings"></a> [fail\_on\_warnings](#input\_fail\_on\_warnings) | Whether warnings should return an error while API Gateway is creating or updating the resource using an OpenAPI specification. Defaults to `false`. Applicable for HTTP APIs | `bool` | `null` | no |
| <a name="input_hosted_zone_name"></a> [hosted\_zone\_name](#input\_hosted\_zone\_name) | Optional domain name of the Hosted Zone where the domain should be created | `string` | `null` | no |
| <a name="input_ip_address_type"></a> [ip\_address\_type](#input\_ip\_address\_type) | The IP address types that can invoke the API. Valid values: ipv4, dualstack. Use ipv4 to allow only IPv4 addresses to invoke your API, or use dualstack to allow both IPv4 and IPv6 addresses to invoke your API. Defaults to ipv4. | `string` | `null` | no |
| <a name="input_mutual_tls_authentication"></a> [mutual\_tls\_authentication](#input\_mutual\_tls\_authentication) | The mutual TLS authentication configuration for the domain name | `map(string)` | `{}` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the API. Must be less than or equal to 128 characters in length | `string` | `""` | no |
| <a name="input_protocol_type"></a> [protocol\_type](#input\_protocol\_type) | The API protocol. Valid values: `HTTP`, `WEBSOCKET` | `string` | `"HTTP"` | no |
| <a name="input_route_key"></a> [route\_key](#input\_route\_key) | Part of quick create. Specifies any route key. Applicable for HTTP APIs | `string` | `null` | no |
| <a name="input_route_selection_expression"></a> [route\_selection\_expression](#input\_route\_selection\_expression) | The route selection expression for the API. Defaults to `$request.method $request.path` | `string` | `null` | no |
| <a name="input_routes"></a> [routes](#input\_routes) | Map of API gateway routes with integrations | <pre>map(object({<br/>    # Route<br/>    authorizer_key             = optional(string)<br/>    api_key_required           = optional(bool)<br/>    authorization_scopes       = optional(list(string), [])<br/>    authorization_type         = optional(string)<br/>    authorizer_id              = optional(string)<br/>    model_selection_expression = optional(string)<br/>    operation_name             = optional(string)<br/>    request_models             = optional(map(string), {})<br/>    request_parameter = optional(object({<br/>      request_parameter_key = optional(string)<br/>      required              = optional(bool, false)<br/>    }), {})<br/>    route_response_selection_expression = optional(string)<br/><br/>    # Route settings<br/>    data_trace_enabled       = optional(bool)<br/>    detailed_metrics_enabled = optional(bool)<br/>    logging_level            = optional(string)<br/>    throttling_burst_limit   = optional(number)<br/>    throttling_rate_limit    = optional(number)<br/><br/>    # Stage - Route response<br/>    route_response = optional(object({<br/>      create                     = optional(bool, false)<br/>      model_selection_expression = optional(string)<br/>      response_models            = optional(map(string))<br/>      route_response_key         = optional(string, "$default")<br/>    }), {})<br/><br/>    # Integration<br/>    integration = object({<br/>      connection_id             = optional(string)<br/>      vpc_link_key              = optional(string)<br/>      connection_type           = optional(string)<br/>      content_handling_strategy = optional(string)<br/>      credentials_arn           = optional(string)<br/>      description               = optional(string)<br/>      method                    = optional(string)<br/>      subtype                   = optional(string)<br/>      type                      = optional(string, "AWS_PROXY")<br/>      uri                       = optional(string)<br/>      passthrough_behavior      = optional(string)<br/>      payload_format_version    = optional(string)<br/>      request_parameters        = optional(map(string), {})<br/>      request_templates         = optional(map(string), {})<br/>      response_parameters = optional(list(object({<br/>        mappings    = map(string)<br/>        status_code = string<br/>      })))<br/>      template_selection_expression = optional(string)<br/>      timeout_milliseconds          = optional(number)<br/>      tls_config = optional(object({<br/>        server_name_to_verify = optional(string)<br/>      }))<br/><br/>      # Integration Response<br/>      response = optional(object({<br/>        content_handling_strategy     = optional(string)<br/>        integration_response_key      = optional(string)<br/>        response_templates            = optional(map(string))<br/>        template_selection_expression = optional(string)<br/>      }), {})<br/>    })<br/>  }))</pre> | `{}` | no |
| <a name="input_stage_access_log_settings"></a> [stage\_access\_log\_settings](#input\_stage\_access\_log\_settings) | Settings for logging access in this stage. Use the aws\_api\_gateway\_account resource to configure [permissions for CloudWatch Logging](https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-logging.html#set-up-access-logging-permissions) | <pre>object({<br/>    create_log_group            = optional(bool, true)<br/>    destination_arn             = optional(string)<br/>    format                      = optional(string)<br/>    log_group_name              = optional(string)<br/>    log_group_retention_in_days = optional(number, 30)<br/>    log_group_kms_key_id        = optional(string)<br/>    log_group_skip_destroy      = optional(bool)<br/>    log_group_class             = optional(string)<br/>    log_group_tags              = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_stage_client_certificate_id"></a> [stage\_client\_certificate\_id](#input\_stage\_client\_certificate\_id) | The identifier of a client certificate for the stage. Use the `aws_api_gateway_client_certificate` resource to configure a client certificate. Supported only for WebSocket APIs | `string` | `null` | no |
| <a name="input_stage_default_route_settings"></a> [stage\_default\_route\_settings](#input\_stage\_default\_route\_settings) | The default route settings for the stage | <pre>object({<br/>    data_trace_enabled       = optional(bool, true)<br/>    detailed_metrics_enabled = optional(bool, true)<br/>    logging_level            = optional(string)<br/>    throttling_burst_limit   = optional(number, 500)<br/>    throttling_rate_limit    = optional(number, 1000)<br/>  })</pre> | `{}` | no |
| <a name="input_stage_description"></a> [stage\_description](#input\_stage\_description) | The description for the stage. Must be less than or equal to 1024 characters in length | `string` | `null` | no |
| <a name="input_stage_name"></a> [stage\_name](#input\_stage\_name) | The name of the stage. Must be between 1 and 128 characters in length | `string` | `"$default"` | no |
| <a name="input_stage_tags"></a> [stage\_tags](#input\_stage\_tags) | A mapping of tags to assign to the stage resource | `map(string)` | `{}` | no |
| <a name="input_stage_variables"></a> [stage\_variables](#input\_stage\_variables) | A map that defines the stage variables for the stage | `map(string)` | `{}` | no |
| <a name="input_subdomain_record_types"></a> [subdomain\_record\_types](#input\_subdomain\_record\_types) | A list of record types to create for the subdomain(s) | `list(string)` | <pre>[<br/>  "A",<br/>  "AAAA"<br/>]</pre> | no |
| <a name="input_subdomains"></a> [subdomains](#input\_subdomains) | An optional list of subdomains to use for API gateway | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to API gateway resources | `map(string)` | `{}` | no |
| <a name="input_target"></a> [target](#input\_target) | Part of quick create. Quick create produces an API with an integration, a default catch-all route, and a default stage which is configured to automatically deploy changes. For HTTP integrations, specify a fully qualified URL. For Lambda integrations, specify a function ARN. The type of the integration will be HTTP\_PROXY or AWS\_PROXY, respectively. Applicable for HTTP APIs | `string` | `null` | no |
| <a name="input_vpc_link_tags"></a> [vpc\_link\_tags](#input\_vpc\_link\_tags) | A map of tags to add to the VPC Links created | `map(string)` | `{}` | no |
| <a name="input_vpc_links"></a> [vpc\_links](#input\_vpc\_links) | Map of VPC Link definitions to create | <pre>map(object({<br/>    name               = optional(string)<br/>    security_group_ids = optional(list(string))<br/>    subnet_ids         = optional(list(string))<br/>    tags               = optional(map(string), {})<br/>  }))</pre> | `{}` | no |

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

## Authors

Module managed by [Anton Babenko](https://github.com/antonbabenko). Check out [serverless.tf](https://serverless.tf) to learn more about doing serverless with Terraform.

Please reach out to [Betajob](https://www.betajob.com/) if you are looking for commercial support for your Terraform, AWS, or serverless project.

## License

Apache 2 Licensed. See [LICENSE](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/tree/master/LICENSE) for full details.
