resource "aws_alb" "lb" {
  security_groups = concat([aws_security_group.lb.id], var.security_groups)
  subnets         = var.subnets

  access_logs {
    bucket  = aws_s3_bucket.logs.bucket
    enabled = true
  }

  tags = var.tags
}

resource "aws_lb_listener" "redirect" {
  load_balancer_arn = aws_alb.lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "lb" {
  load_balancer_arn = aws_alb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = aws_acm_certificate_validation.wildcard.certificate_arn
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}
