resource "aws_security_group" "lb" {
  vpc_id = var.vpc_id

  tags = var.tags
}

resource "aws_security_group_rule" "http" {
  type        = "ingress"
  from_port   = "80"
  to_port     = "80"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "http6" {
  type             = "ingress"
  from_port        = "80"
  to_port          = "80"
  protocol         = "tcp"
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "https" {
  type        = "ingress"
  from_port   = "443"
  to_port     = "443"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "https6" {
  type             = "ingress"
  from_port        = "443"
  to_port          = "443"
  protocol         = "tcp"
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "egress-https" {
  type        = "egress"
  from_port   = "443"
  to_port     = "443"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "egress-https6" {
  type             = "egress"
  from_port        = "443"
  to_port          = "443"
  protocol         = "tcp"
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = aws_security_group.lb.id
}
