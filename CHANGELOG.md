# Change Log

All notable changes to this project will be documented in this file.

<a name="unreleased"></a>
## [Unreleased]



<a name="v1.1.0"></a>
## [v1.1.0] - 2021-05-25

- chore: Remove check boxes that don't render properly in module doc ([#40](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/40))
- chore: update CI/CD to use stable `terraform-docs` release artifact and discoverable Apache2.0 license ([#38](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/38))
- chore: Updated versions in README ([#37](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/37))


<a name="v1.0.0"></a>
## [v1.0.0] - 2021-04-26

- feat: Shorten outputs (removing this_), added domain name to outputs ([#34](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/34))


<a name="v0.16.0"></a>
## [v0.16.0] - 2021-04-25

- feat: Add support for default_route_settings ([#32](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/32))


<a name="v0.15.0"></a>
## [v0.15.0] - 2021-04-24

- feat: Added support for mTLS and the ability to disable default endpoint ([#29](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/29))
- chore: update documentation and pin `terraform_docs` version to avoid future changes ([#28](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/28))


<a name="v0.14.0"></a>
## [v0.14.0] - 2021-03-16

- feat: Add support for OpenAPI definition ([#27](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/27))


<a name="v0.13.0"></a>
## [v0.13.0] - 2021-03-10

- feat: Added example of step-functions integration ([#26](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/26))


<a name="v0.12.0"></a>
## [v0.12.0] - 2021-03-09

- feat: Added VPC integration ([#25](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/25))


<a name="v0.11.0"></a>
## [v0.11.0] - 2021-03-06

- fix: Remove workaround related to passthrough_behavior for older providers ([#24](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/24))
- chore: align ci-cd static checks to use individual minimum Terraform versions ([#23](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/23))
- fix: bump min supported version due to types unsupported on current ([#22](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/22))
- chore: add ci-cd workflow for pre-commit checks ([#21](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/21))


<a name="v0.10.0"></a>
## [v0.10.0] - 2021-02-20

- chore: update documentation based on latest `terraform-docs` which includes module and resource sections ([#19](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/19))


<a name="v0.9.0"></a>
## [v0.9.0] - 2021-02-14

- feat: support authorization_type and authorizer_id on routes ([#17](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/17))


<a name="v0.8.0"></a>
## [v0.8.0] - 2021-01-14

- feat: New useful outputs to use with route53 ([#11](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/11))


<a name="v0.7.0"></a>
## [v0.7.0] - 2021-01-14

- chore: Updated example after lambda module has been updated ([#16](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/16))
- fix: default API Gateway integration method is POST ([#14](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/14))


<a name="v0.6.0"></a>
## [v0.6.0] - 2021-01-14

- fix: Integration URI is not always a lambda_arn ([#15](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/15))


<a name="v0.5.0"></a>
## [v0.5.0] - 2020-11-24

- fix: Updated supported Terraform versions


<a name="v0.4.0"></a>
## [v0.4.0] - 2020-09-08

- feat: add VPC Links resource to allow access to private resources ([#3](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/3))


<a name="v0.3.0"></a>
## [v0.3.0] - 2020-08-14

- feat: Updated version requirements for AWS provider v3 and Terraform 0.13
- Added route53 record into example (closes [#1](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/1))
- Improved complete example


<a name="v0.2.0"></a>
## [v0.2.0] - 2020-06-07

- Added support for access logs


<a name="v0.1.0"></a>
## v0.1.0 - 2020-06-05

- Adding API Gateway module


[Unreleased]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v1.1.0...HEAD
[v1.1.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v1.0.0...v1.1.0
[v1.0.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v0.16.0...v1.0.0
[v0.16.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v0.15.0...v0.16.0
[v0.15.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v0.14.0...v0.15.0
[v0.14.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v0.13.0...v0.14.0
[v0.13.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v0.12.0...v0.13.0
[v0.12.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v0.11.0...v0.12.0
[v0.11.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v0.10.0...v0.11.0
[v0.10.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v0.9.0...v0.10.0
[v0.9.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v0.8.0...v0.9.0
[v0.8.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v0.7.0...v0.8.0
[v0.7.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v0.6.0...v0.7.0
[v0.6.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v0.5.0...v0.6.0
[v0.5.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v0.4.0...v0.5.0
[v0.4.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v0.3.0...v0.4.0
[v0.3.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v0.2.0...v0.3.0
[v0.2.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v0.1.0...v0.2.0
