variable "vpc_id" {
  type        = string
  description = "VPC id for deploying the instance"
}

variable "az" {
  type        = string
  description = "Availability zone for the instance "
}

variable "security_groups" {
  type        = list(string)
  description = "Security groups to add to the instance"
}

variable "subnet" {
  type        = string
  description = "Subnet id for the instance"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to all resources"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the ECS cluster to join"
}

variable "iam_group" {
  type        = string
  description = "Name of the IAM group who has SSH access"
}

variable "instance_type" {
  type        = string
  description = "Type of the instance to deploy"
  default     = "t3a.micro"
}

variable "persistent_volume_size" {
  type        = number
  description = "Size of the persistent volume in GB"
  default     = 100
}

variable "ephemeral_volume_size" {
  type        = number
  description = "Size of the ephemeral volume in GB"
  default     = 30
}
