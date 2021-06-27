terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
 
  backend "s3" {
    key    = "terraform-aws/terraform.tfstate"
  }

}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

locals {
  environment = "${lookup(var.workspace_to_environment_map, terraform.workspace, "dev")}"
  size = "${local.environment == "dev" ? lookup(var.workspace_to_size_map, terraform.workspace, "small") : var.environment_to_size_map[local.environment]}"
}


