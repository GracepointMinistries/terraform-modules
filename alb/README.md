# ALB Module

This module creates an ALB with a default listener that:

1. Redirects HTTP requests to HTTPS
2. Has a wildcard cert for a given domain associated with it

It expects to be given a hosted zone domain name that exists in Route53 that can be managed by Terraform. Applications can be deployed behind this ALB by creating new listener rules and binding them to the exported HTTPS listener.
