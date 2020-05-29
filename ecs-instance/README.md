# ECS Instance Module

This module creates a basic ECS EC2 instance with persistent storage and an elastic ip that can survive reprovisioning. SSH access is managed by syncing user keys from members of a given IAM group.

Since we're trying to minimize the AWS footprint, there's nothing like a bastion host, so this exposes the host to public SSH.
