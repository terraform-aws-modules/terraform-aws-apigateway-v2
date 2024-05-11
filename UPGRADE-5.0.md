# Upgrade from v4.x to v5.x

Please consult the `examples` directory for reference example configurations. If you find a bug, please open an issue with supporting configuration to reproduce.

## List of backwards incompatible changes

- Minimum supported Terraform version increased to `v1.3` to support Terraform state `moved` blocks as well as other advanced features

## Additional changes

### Added

   -

### Modified

   -

### Removed

   -

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

### Diff of Before (v4.0) vs After (v5.0)

```diff
 module "apigateway_v2" {
   source  = "terraform-aws-modules/apigateway-v2/aws"
-  version = "~> 4.0"
+  version = "~> 5.0"

}
```

## Terraform State Moves
