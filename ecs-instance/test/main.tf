provider "aws" {
  region  = "us-east-1"
  version = "~> 2.64"
}

provider "random" {
  version = "~> 2.2"
}

provider "template" {
  version = "~> 2.1"
}

provider "tls" {
  version = "~> 2.1"
}

provider "null" {
  version = "~> 2.1"
}

module "vpc" {
  source = "../../vpc"

  azs    = ["us-east-1a", "us-east-1b"]
  subnet = "10.0.0.0/16"
  tags = {
    Testing = "example instance"
  }
}

resource "random_id" "run" {
  byte_length = 8
}

resource "aws_ecs_cluster" "ecs" {
  name = "testing-cluster-${random_id.run.hex}"
  tags = {
    Testing = "example instance"
  }
}

resource "aws_iam_group" "operators" {
  name = "testing_${random_id.run.hex}"
}

resource "aws_iam_user" "operator" {
  name = "operator_${random_id.run.hex}"
}

resource "aws_iam_group_membership" "team" {
  name = "testing_members_${random_id.run.hex}"
  users = [
    aws_iam_user.operator.name
  ]

  group = aws_iam_group.operators.name
}

resource "tls_private_key" "user" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_iam_user_ssh_key" "user" {
  username   = aws_iam_user.operator.name
  encoding   = "SSH"
  public_key = tls_private_key.user.public_key_openssh
}

module "instance" {
  source = "../"

  vpc_id           = module.vpc.vpc
  ecs_cluster_name = aws_ecs_cluster.ecs.name
  subnet           = module.vpc.subnet_ids[1]
  az               = module.vpc.azs[1]
  security_groups  = [module.vpc.security_group]
  iam_group        = aws_iam_group.operators.name
  tags = {
    Testing = "example instance"
  }
}

output "instance_info" {
  value = jsonencode(module.instance)
}

output "user" {
  value     = aws_iam_user.operator.name
  sensitive = true
}

output "private_key" {
  value     = tls_private_key.user.private_key_pem
  sensitive = true
}
