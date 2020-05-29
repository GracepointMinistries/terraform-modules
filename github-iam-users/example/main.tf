provider "aws" {
  region  = "us-east-1"
  version = "~> 2.64"
}

provider "github" {
  version      = "~> 2.8"
  anonymous    = false
  individual   = false
  organization = "GracepointMinistries"
}

provider "random" {
  version = "~> 2.2"
}

resource "random_id" "run" {
  byte_length = 8
}

module "github-users" {
  source = "../"

  github_team = "testing-team"
  iam_group   = "users_${random_id.run.hex}"
  user_prefix = random_id.run.hex
}

output "user_info" {
  value = jsonencode(module.github-users)
}
