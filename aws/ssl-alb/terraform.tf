terraform {
  required_version = "1.13.0"

  backend "s3" {
    bucket  = "terraform-tfstate"
    key     = "jwt-alb/terraform.tfstate"
    encrypt = true
    region  = "ap-northeast-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0.0"
    }
  }

}

provider "aws" {
  region = "ap-northeast-1"
}