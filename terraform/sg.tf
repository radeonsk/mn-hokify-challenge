resource "aws_security_group" "server" {
  name        = "hokify server"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = "hokify server sg"
  }

}

resource "aws_security_group_rule" "allow-all-out" {
  security_group_id = aws_security_group.server.id
  description       = "allow to connect anywhere out"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "allow-8080" {
  security_group_id = aws_security_group.server.id
  description       = "8080 from internet"
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}