provider "aws" {
  region  = "us-east-1"
  version = "~> 2.64"
}

module "vpc" {
  source = "../../vpc"

  azs    = ["us-east-1a", "us-east-1b"]
  subnet = "10.0.0.0/16"
  tags = {
    Testing = "example alb"
  }
}

module "alb" {
  source = "../"

  vpc_id               = module.vpc.vpc
  subnets              = module.vpc.subnet_ids
  security_groups      = [module.vpc.security_group]
  domain               = "testing1.gracepointonline.org"
  force_destroy_bucket = true
  tags = {
    Testing = "example alb"
  }
}

output "alb_info" {
  value = jsonencode(module.alb)
}
