# Upgrade from v4.x to v5.x

Please consult the `examples` directory for reference example configurations. If you find a bug, please open an issue with supporting configuration to reproduce.

## List of backwards incompatible changes

- Minimum supported Terraform version increased to `v1.3` to support Terraform state `moved` blocks as well as other advanced features
- The `apigatewayv2_` and `default_apigatewayv2_` prefixes has been removed from the output names
- When a custom domain is used, the execution endpoint is disabled automatically; this is to ensure that requests are sent via the custom domain
- For `authorizers`, the `audience` and `issuer` properties are now nested under `jwt_configuration` to better match the upstream API

## Additional changes

- Minimum supported Terraform AWS provider raised to `v5.37.0` to support recent bug fixes in the provider
- Default values for `api_key_selection_expression`, `route_selection_expression` variables set to `null` (still matches prior value v4.x version but is set as `null` now)
- The input data structure for `routes` (was `integrations`) has been updated and now uses optional inputs

### Added

   - Support for creating a websocket API endpoint
   - Support for creating Route53 alias records for custom domain names w/ support for multiple sub-domains using a wildcard API Gateway custom domain name
   - Support for creating ACM certificate for custom domain
   - Support for automatically deploying the stage when updates have been made (for Websocket, HTTP is always auto-deployed by the API)

### Modified

   - Stage access log group settings are now embedded into the `stage_access_log_settings` variable
   - API mapping is created automatically when using a custom domain
   - Default values of 500 and 1000 have been set for `throttling_burst_limit` and `throttling_rate_limit` respectively to ensure users do not face errors when deploying APIs for the first time and not configuring these
   - Default values for the log group name (`"/aws/apigateway/${var.name}/${var.stage_name}"`) and retention period (`30`) have been provided for the stage access logs log group

### Removed

   - None

### Variable and output changes

1. Removed variables:

   - `create_api_gateway`
   - `create_default_stage_api_mapping`
   - `create_default_stage_access_log_group` -> replaced by `create_log_group` set within `stage_access_log_settings`
   - `default_stage_access_log_*` -> replaced by setting values within `stage_access_log_settings`
   - `create_vpc_link`
   - `default_stage_access_log_destination_arn`
   - `domain_name_tags`

2. Renamed variables:

   - `integrations` -> `routes`
   - `create_default_stage` -> `create_stage`
   - `create_api_domain_name` -> `create_domain_name`
   - `default_route_settings` -> `stage_default_route_settings`
   - `default_stage_tags` -> `stage_tags`

3. Added variables:

   - `create_domain_name`
   - `create_domain_records`
   - `subdomains`
   - `create_certificate`
   - `stage_access_log_settings`
   - `stage_client_certificate_id`
   - `stage_description`
   - `stage_name`
   - `stage_variables`
   - `deploy_stage`

4. Removed outputs:

   - `default_apigatewayv2_stage_domain_name`
   - `aws_apigatewayv2_api_mapping`
   - `apigatewayv2_vpc_link_id` -> replaced by `vpc_links`
   - `apigatewayv2_vpc_link_arn` -> replaced by `vpc_links`
   - `apigatewayv2_authorizer_id` -> replaced by `authorizers`

5. Renamed outputs:

   - `apigatewayv2_api_` -> prefix replaced with `api_`
   - `default_apigatewayv2_stage_` prefix replaced with `stage_`
   - `apigatewayv2_domain_` prefix replaced with `domain_`

6. Added outputs:

   - `acm_certificate_arn`
   - `integrations`
   - `routes`
   - `stage_access_logs_cloudwatch_log_group_name`
   - `stage_access_logs_cloudwatch_log_group_arn`

## Upgrade Migrations

### Diff of Before (v4.0) vs After (v5.0)

```diff
 module "apigateway_v2" {
   source  = "terraform-aws-modules/apigateway-v2/aws"
-  version = "~> 4.0"
+  version = "~> 5.0"

-  create_default_stage_access_log_group = true
-  default_stage_access_log_format = "$context.identity.sourceIp"
+  stage_access_log_settings = {
+    create_log_group = true
+    format           = "$context.identity.sourceIp"
+  }

  authorizers = {
    "cognito" = {
      authorizer_type  = "JWT"
      identity_sources = "$request.header.Authorization"
      name             = "cognito"

-     audience = ["d6a38afd-45d6-4874-d1aa-3c5c558aqcc2"]
-     issuer   = "https://${aws_cognito_user_pool.this.endpoint}"
      jwt_configuration = {
+       audience = ["d6a38afd-45d6-4874-d1aa-3c5c558aqcc2"]
+       issuer   = "https://${aws_cognito_user_pool.this.endpoint}"
      }
    }
  }

-  integrations = {
+  routes = {
    "POST /start-step-function" = {
-     integration_type    = "AWS_PROXY"
-     integration_subtype = "StepFunctions-StartExecution"
-     credentials_arn     = module.step_function.role_arn

-     request_parameters = jsonencode({
-       StateMachineArn = module.step_function.state_machine_arn
-     })

-     payload_format_version = "1.0"
-     timeout_milliseconds   = 12000

+     integration = {
+       type            = "AWS_PROXY"
+       subtype         = "StepFunctions-StartExecution"
+       credentials_arn = module.step_function.role_arn

+       request_parameters = {
+         StateMachineArn = module.step_function.state_machine_arn
+       }

+       payload_format_version = "1.0"
+       timeout_milliseconds   = 12000
+     }
    }

    "GET /some-route-with-authorizer-and-scope" = {
-     lambda_arn             = module.lambda_function.lambda_function_arn
-     payload_format_version = "2.0"
-     authorization_type     = "JWT"
-     authorizer_key         = "cognito"
-     authorization_scopes   = "tf/something.relevant.read,tf/something.relevant.write"

+     authorization_type   = "JWT"
+     authorizer_key       = "cognito"
+     authorization_scopes = ["tf/something.relevant.read", "tf/something.relevant.write"]

+     integration = {
+       uri                    = module.lambda_function.lambda_function_arn
+       payload_format_version = "2.0"
+     }
    }

    "$default" = {
-     lambda_arn = module.lambda_function.lambda_function_arn
-     tls_config = jsonencode({
-       server_name_to_verify = local.domain_name
-     })

-     response_parameters = jsonencode([
-       {
-         status_code = 500
-         mappings = {
-           "append:header.header1" = "$context.requestId"
-           "overwrite:statuscode"  = "403"
-         }
-       },
-       {
-         status_code = 404
-         mappings = {
-           "append:header.error" = "$stageVariables.environmentId"
-         }
-       }
-     ])

+     integration = {
+       uri = module.lambda_function.lambda_function_arn
+       tls_config = jsonencode({
+         server_name_to_verify = local.domain_name
+       })

+       response_parameters = [
+         {
+           status_code = 500
+           mappings = {
+             "append:header.header1" = "$context.requestId"
+             "overwrite:statuscode"  = "403"
+           }
+         },
+         {
+           status_code = 404
+           mappings = {
+             "append:header.error" = "$stageVariables.environmentId"
+           }
+         }
+       ]
+     }
    }
  }
}
```
