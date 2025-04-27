terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.96"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 2.0"
    }
  }
}
