terraform {
    backend "s3" {
        key = "labs/find-nation/terraform.tfstate"
        encrypt = true
    }
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
