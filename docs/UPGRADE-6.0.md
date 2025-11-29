# Upgrade from v5.x to v6.x

If you have any questions regarding this upgrade process, please consult the [`examples`](https://github.com/terraform-aws-modules/terraform-aws-apigateway-v2/tree/master/examples) directory:
If you find a bug, please open an issue with supporting configuration to reproduce.

## List of backwards incompatible changes

- Terraform `v1.5.7` is now minimum supported version
- AWS provider `v6.0` is now minimum supported version

## Additional changes

### Added

-

### Modified

- Variable definitions now contain detailed `object` types in place of the previously used any type

### Variable and output changes

1. Removed variables:

    -

2. Renamed variables:

    -

3. Added variables:

    -

4. Removed outputs:

    -

5. Renamed outputs:

    -

6. Added outputs:

    -

## Upgrade Migrations

### Before 5.x Example

```hcl
module "apigateway" {
  source  = "terraform-aws-modules/apigateway-v2/aws/"
  version = "~> 5.0"

  # Truncated for brevity ...

}
```

### After 6.x Example

```hcl
module "apigateway" {
  source  = "terraform-aws-modules/apigateway-v2/aws/"
  version = "~> 6.0"

  # Truncated for brevity ...

}
```

### State Changes

TBD
