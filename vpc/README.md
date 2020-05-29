# VPC Module

This module creates a low-ish cost VPC with a single subnet behind an internet gateway for public IP access. It avoids the use of private subnets due to the high cost/maintenance of setting up NAT for private machines that need internet access.

Additionally, it creates a base security group for internal communication that is unrestricted. This is likely enough for most use-cases, but if strict security controls are required around what talks to what in the internal network, then don't use these.
