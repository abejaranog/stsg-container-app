terraform {
  backend "s3" {
    bucket = "eks-test-yopdev-qa"
    key    = "test"
    region = "us-west-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.30"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.4.3"
    }
  }
}

provider "aws" {
  region = var.region
}
