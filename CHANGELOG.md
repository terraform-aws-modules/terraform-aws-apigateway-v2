# Changelog

All notable changes to this project will be documented in this file.

## [4.0.0](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v3.1.1...v4.0.0) (2024-03-14)


### ⚠ BREAKING CHANGES

* Added creation of CW Log Group. Bump AWS provider version. (#103)

### Features

* Added creation of CW Log Group. Bump AWS provider version. ([#103](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/103)) ([c123558](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/commit/c12355835449be55218914677d5fb5d8f2c2f4b0))

## [3.1.1](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v3.1.0...v3.1.1) (2024-03-06)


### Bug Fixes

* Update CI workflow versions to remove deprecated runtime warnings ([#102](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/102)) ([c052dfe](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/commit/c052dfe4c6cab30a638303f6abbd7861937adc60))

## [3.1.0](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v3.0.0...v3.1.0) (2024-02-12)


### Features

* Add variable create_route to control creation of route ([#98](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/98)) ([68ad2b1](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/commit/68ad2b183a4872e29890784290b5925beee1dd29))

## [3.0.0](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v2.2.2...v3.0.0) (2024-02-12)


### ⚠ BREAKING CHANGES

* Added the fail_on_warnings variable, bumped Terraform version to 1.0+ (#96)

### Features

* Added the fail_on_warnings variable, bumped Terraform version to 1.0+ ([#96](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/96)) ([26859db](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/commit/26859db0a5d651903469f6fabeda1e341867c45d))

### [2.2.2](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v2.2.1...v2.2.2) (2023-01-24)


### Bug Fixes

* Use a version for  to avoid GitHub API rate limiting on CI workflows ([#85](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/85)) ([9229fa2](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/commit/9229fa2ec7f01f9187b0ddcae3a29929e8146417))

### [2.2.1](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v2.2.0...v2.2.1) (2022-10-27)


### Bug Fixes

* Update CI configuration files to use latest version ([#84](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/84)) ([13bd65e](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/commit/13bd65e192cb39f25a7e7bd281470dd1f7c073bd))

## [2.2.0](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v2.1.0...v2.2.0) (2022-09-12)


### Features

* Enable route_settings in default stage ([#80](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/80)) ([a13ef33](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/commit/a13ef3308fc0b4efef53f7fefb8bc7f8012a8336))

## [2.1.0](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v2.0.0...v2.1.0) (2022-08-15)


### Features

* Added API GW Authorizer IDs to outputs ([#76](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/76)) ([05da6b1](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/commit/05da6b19a0150d2d39db97968fa7214e9e4fa580))

## [2.0.0](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v1.9.0...v2.0.0) (2022-06-15)


### ⚠ BREAKING CHANGES

* Upgraded AWS provider to v4 everywhere (#74)

### Features

* Upgraded AWS provider to v4 everywhere ([#74](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/74)) ([2f8ad61](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/commit/2f8ad61a8668eb7559115f31e62c502ed2ea09c3))

## [1.9.0](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v1.8.0...v1.9.0) (2022-06-13)


### Features

* Add pass-through of ownership_verification_certificate_arn to domain_name ([#72](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/72)) ([5709873](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/commit/57098730dc48785f0836f9eb322008b054f91134))

## [1.8.0](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v1.7.0...v1.8.0) (2022-05-27)


### Features

* Added enable_simple_responses and authorizer_credentials_arn to authorizers ([#71](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/71)) ([1467b95](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/commit/1467b95c8309d82332857a9c2790ca25f2edc2ec))

## [1.7.0](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v1.6.1...v1.7.0) (2022-04-06)


### Features

* Added support for ttl in authorizer resource ([#68](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/68)) ([ce1faf9](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/commit/ce1faf96b191228bf891864f50d284078f54b0a0))

### [1.6.1](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v1.6.0...v1.6.1) (2022-04-01)


### Bug Fixes

* Add support for passing authorization_scopes on routes with JWT authorizer ([#67](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/67)) ([c2b8d6b](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/commit/c2b8d6bd8b11fa83ccd13f3ccc74844d328f59ad))

## [1.6.0](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v1.5.1...v1.6.0) (2022-03-25)


### Features

* Added support for Authorizers ([#64](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/64)) ([5cd32e0](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/commit/5cd32e0360c866c25d8a8c6300e638143335a665))

## [1.5.1](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v1.5.0...v1.5.1) (2021-11-22)


### Bug Fixes

* update CI/CD process to enable auto-release workflow ([#60](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/60)) ([55f5c1d](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/commit/55f5c1d74b4b61cf228f66c2d4a7f940e90f01b7))

<a name="v1.5.0"></a>
## [v1.5.0] - 2021-11-01

- feat: Add support for response_parameters in integrations ([#58](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/58))


<a name="v1.4.0"></a>
## [v1.4.0] - 2021-09-23

- Feat: Add create_before_destroy lifecycle to integration resources ([#55](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/55))


<a name="v1.3.0"></a>
## [v1.3.0] - 2021-09-16

- fix: Fixed output when create_api_domain_name is false ([#44](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/44))
- chore: Fixed GH Action with terraform-docs


<a name="v1.2.0"></a>
## [v1.2.0] - 2021-08-26

- feat: Add support for tls_config in integrations ([#51](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/51))
- fix: Fixed source_arn in example (fixes [#41](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/issues/41))


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


[Unreleased]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v1.5.0...HEAD
[v1.5.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v1.4.0...v1.5.0
[v1.4.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v1.3.0...v1.4.0
[v1.3.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v1.2.0...v1.3.0
[v1.2.0]: https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/compare/v1.1.0...v1.2.0
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
