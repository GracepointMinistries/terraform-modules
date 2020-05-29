provider "aws" {
  region  = "us-east-1"
  version = "~> 2.64"
}

module "vpc" {
  source = "../"

  azs    = ["us-east-1a", "us-east-1b"]
  subnet = "10.0.0.0/16"
  tags = {
    Testing = "example vpc"
  }
}

output "vpc_info" {
  value = jsonencode(module.vpc)
}
