resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/24"

  tags = {
    Name = "hokify VPC"
  }
}

resource "aws_subnet" "server" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.0.0/26"

  tags = {
    Name = "hokify server subnet"
  }
}
