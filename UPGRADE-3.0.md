# Upgrade from v1.x to v2.x

Please consult the `examples` directory for reference example configurations. If you find a bug, please open an issue with supporting configuration to reproduce.

## List of backwards incompatible changes

- TODO

## Additional changes

### Added

- TODO

### Modified

- TODO

### Removed

- TODO

### Variable and output changes

1. Removed variables:

    - TODO

2. Renamed variables:

    - TODO

3. Added variables:

    - TODO

4. Removed outputs:

    - TODO

5. Renamed outputs:

    - TODO

6. Added outputs:

    - TODO

## Upgrade Migrations

### Before 1.x Example

```hcl
module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"
  version = "~> 1.0"

  # TODO

  tags = {
    Environment = "test"
    GithubRepo  = "terraform-aws-apigateway-v2"
    GithubOrg   = "terraform-aws-modules"
  }
}
```

### After 2.x Example

```hcl
module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"
  version = "~> 1.0"

  # TODO

  tags = {
    Environment = "test"
    GithubRepo  = "terraform-aws-apigateway-v2"
    GithubOrg   = "terraform-aws-modules"
  }
}
```
