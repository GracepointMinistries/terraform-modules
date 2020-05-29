output "record" {
  value = aws_alb.lb.dns_name
}

output "alb_zone" {
  value = aws_alb.lb.zone_id
}

output "listener" {
  value = aws_alb_listener.lb.arn
}

output "zone" {
  value = data.aws_route53_zone.domain.id
}

output "domain" {
  value = var.domain
}
