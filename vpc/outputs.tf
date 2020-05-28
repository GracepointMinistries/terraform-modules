output "vpc" {
  value     = aws_vpc.vpc.id
  sensitive = true
}

output "azs" {
  value = var.azs
}

output "subnet_ids" {
  value = aws_subnet.public.*.id
}
