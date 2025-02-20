terraform {
  # Versions configuration
  required_version = "= 1.10.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.85.0"
    }
  }

  # tfstate backend configuration
  backend "s3" {
    bucket  = "BUCKET_NAME"
    key     = "terraform.tfstate"
    encrypt = true
    region  = "ap-northeast-1"
  }
}

# Provider configuration
provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = local.default_tags
  }
}