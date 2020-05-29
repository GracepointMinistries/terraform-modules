output "vpc" {
  value = aws_vpc.vpc.id
}

output "azs" {
  value = var.azs
}

output "subnet_ids" {
  value = aws_subnet.public.*.id
}

output "security_group" {
  value = aws_security_group.internal.id
}
