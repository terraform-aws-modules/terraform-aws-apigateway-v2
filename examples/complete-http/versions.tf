terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws    = ">= 3.24.0"
    random = ">= 2.0"
    null   = ">= 2.0"
    tls    = ">= 3.1"
  }
}
