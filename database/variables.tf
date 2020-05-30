variable "security_groups" {
  type        = list(string)
  description = "Security groups for the database"
}

variable "subnets" {
  type        = list(string)
  description = "Subnet ids for the database"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to all resources"
}

variable "username" {
  type        = string
  default     = "apps"
  description = "The master username for the RDS instance"
}

variable "instance_type" {
  type        = string
  default     = "db.t3.micro"
  description = "The type of RDS instance to provision"
}

variable "engine_version" {
  type        = string
  default     = "12.2"
  description = "The version of postgres to provision the database with"
}

variable "storage_size" {
  type        = number
  default     = 100
  description = "The size of the database disk in GB"
}

# things that should really only be used in testing

variable "publicly_accessible" {
  type        = bool
  default     = false
  description = "Whether the instance should be made publically accessible or not"
}

variable "skip_final_snapshot" {
  type        = bool
  default     = false
  description = "Skip creating a final snapshot when destroying instance"
}

variable "deletion_protection" {
  type        = bool
  default     = true
  description = "Protect instance from being deleteds"
}
