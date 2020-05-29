data "aws_route53_zone" "domain" {
  name = "${var.domain}."
}

resource "aws_acm_certificate" "wildcard" {
  domain_name       = "*.${var.domain}"
  validation_method = "DNS"

  # general practice to turn off cert transparency logs
  # to avoid domain enumeration tools
  options {
    certificate_transparency_logging_preference = "DISABLED"
  }

  # avoid dependency of ALB listener when recreating cert
  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_route53_record" "wildcard_validation" {
  name    = aws_acm_certificate.wildcard.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.wildcard.domain_validation_options[0].resource_record_type
  zone_id = data.aws_route53_zone.domain.id
  records = [aws_acm_certificate.wildcard.domain_validation_options[0].resource_record_value]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "wildcard" {
  certificate_arn         = aws_acm_certificate.wildcard.arn
  validation_record_fqdns = [aws_route53_record.wildcard_validation.fqdn]
}
