module "context" {
  source    = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.24.1"
  namespace = "example"
  stage     = "dev"
  name      = "my-tf-example"
  attributes = [
    "just-an-example"
  ]
}
