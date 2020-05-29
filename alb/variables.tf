variable "domain" {
  type        = string
  description = "Route53-hosted domain where applications will be deployed"
}

variable "vpc_id" {
  type        = string
  description = "VPC id for deploying the load balancer"
}

variable "security_groups" {
  type        = list(string)
  description = "Security groups to allow load balancer communication with VPC network"
}

variable "subnets" {
  type        = list(string)
  description = "Subnet ids for the load balancer"
}

variable "load_balancer_bucket_prefix" {
  type        = string
  description = "S3 bucket prefix for ALB logs"
  default     = "lb-"
}

variable "force_destroy_bucket" {
  type        = bool
  description = "Destroy log bucket on delete even if not empty"
  default     = false
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to all resources"
}
