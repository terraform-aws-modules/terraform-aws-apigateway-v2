module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name     = "aws-ws-connections"
  hash_key = "connection_id"

  attributes = [
    {
      name = "connection_id"
      type = "S"
    }
  ]

  tags = {
    Terraform = "true"
  }
}

