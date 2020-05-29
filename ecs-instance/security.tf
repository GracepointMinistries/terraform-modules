resource "aws_security_group" "instance" {
  vpc_id = var.vpc_id

  tags = var.tags
}

resource "aws_security_group_rule" "ssh" {
  type        = "ingress"
  from_port   = "22"
  to_port     = "22"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.instance.id
}

resource "aws_security_group_rule" "ssh6" {
  type             = "ingress"
  from_port        = "22"
  to_port          = "22"
  protocol         = "tcp"
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = aws_security_group.instance.id
}

resource "aws_security_group_rule" "ping" {
  type        = "ingress"
  from_port   = -1
  to_port     = -1
  protocol    = "icmp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.instance.id
}

resource "aws_security_group_rule" "ping6" {
  type             = "ingress"
  from_port        = -1
  to_port          = -1
  protocol         = "icmp"
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = aws_security_group.instance.id
}

resource "aws_security_group_rule" "egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 65535
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.instance.id
}

resource "aws_security_group_rule" "egress6" {
  type             = "egress"
  from_port        = 0
  to_port          = 65535
  protocol         = "tcp"
  ipv6_cidr_blocks = ["::/0"]

  security_group_id = aws_security_group.instance.id
}
