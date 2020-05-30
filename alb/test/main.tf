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

# create a junk subdomain for testing
provider "random" {
  version = "~> 2.2"
}

resource "random_id" "run" {
  byte_length = 8
}

data "aws_route53_zone" "disposable" {
  name = "disposable.gracepointonline.org."
}

resource "aws_route53_zone" "test_zone" {
  name = "${random_id.run.hex}.disposable.gracepointonline.org"
}

resource "aws_route53_record" "test_zone" {
  zone_id = data.aws_route53_zone.disposable.id
  name    = aws_route53_zone.test_zone.name
  type    = "NS"
  ttl     = "30"

  records = aws_route53_zone.test_zone.name_servers
}

module "alb" {
  source = "../"

  vpc_id               = module.vpc.vpc
  subnets              = module.vpc.subnet_ids
  security_groups      = [module.vpc.security_group]
  domain               = trimsuffix(aws_route53_zone.test_zone.name, ".")
  force_destroy_bucket = true
  tags = {
    Testing = "example alb"
  }
}

output "alb_info" {
  value = jsonencode(module.alb)
}

output "subdomain" {
  value = trimsuffix(aws_route53_zone.test_zone.name, ".")
}
