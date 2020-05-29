resource "aws_security_group" "internal" {
  vpc_id = aws_vpc.vpc.id

  tags = var.tags
}

resource "aws_security_group_rule" "ingress" {
  type      = "ingress"
  from_port = 0
  to_port   = 65535
  protocol  = "all"
  self      = true

  security_group_id = aws_security_group.internal.id
}

resource "aws_security_group_rule" "egress" {
  type      = "egress"
  from_port = 0
  to_port   = 65535
  protocol  = "all"
  self      = true

  security_group_id = aws_security_group.internal.id
}
