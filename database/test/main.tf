provider "aws" {
  region  = "us-east-1"
  version = "~> 2.64"
}

provider "random" {
  version = "~> 2.2"
}

module "vpc" {
  source = "../../vpc"

  azs    = ["us-east-1a", "us-east-1b"]
  subnet = "10.0.0.0/16"
  tags = {
    Testing = "example database"
  }
}

resource "aws_security_group" "open" {
  vpc_id = module.vpc.vpc

  tags = {
    Testing = "example databasse"
  }
}

resource "aws_security_group_rule" "open" {
  type        = "ingress"
  from_port   = "5432"
  to_port     = "5432"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.open.id
}

module "database" {
  source = "../"

  subnets             = module.vpc.subnet_ids
  security_groups     = [aws_security_group.open.id, module.vpc.security_group]
  publicly_accessible = true
  skip_final_snapshot = true
  deletion_protection = false
  tags = {
    Testing = "example databasse"
  }
}

output "database_info" {
  value = jsonencode(module.database)
}
