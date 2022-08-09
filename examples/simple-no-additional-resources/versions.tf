terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.6.0"
    }
  }
  required_version = ">= 1.2.6"
}
