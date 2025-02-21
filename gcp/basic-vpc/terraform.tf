provider "google" {
  project = local.provider.project_id
  region  = local.provider.region
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.21.0"
    }
  }

  backend "gcs" {
    bucket = "test-terraform-tfstate-574643335037"
  }
}