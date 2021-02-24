terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.29.1, ~> 3"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2"
    }
  }
  required_version = ">= 0.14"
}
