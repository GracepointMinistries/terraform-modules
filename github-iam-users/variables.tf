variable "github_team" {
  type        = string
  description = "Team in an organization used to sync users"
}

variable "iam_group" {
  type        = string
  description = "IAM group to create"
}

variable "user_prefix" {
  type        = string
  description = "Prefix for IAM users"
  default     = ""
}
