variable "azs" {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
  description = "AZs for AWS deployments"
}

variable "subnet" {
  type        = string
  default     = "10.0.0.0/16"
  description = "Controls which /16 subnet is used for the VPC"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to all resources"
}
