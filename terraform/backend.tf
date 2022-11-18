terraform {

}

provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile

  default_tags {
    tags = {
      "Environment" = terraform.workspace
      "Project"     = local.project_name
    }
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}