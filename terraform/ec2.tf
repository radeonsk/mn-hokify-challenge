# Solr standalone

resource "aws_eip" "server" {
  instance = aws_instance.server.id
  domain   = "vpc"

  tags = {
    Name = "hokify Public IP address"
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "server" {
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t3.micro"
  subnet_id               = aws_subnet.server.id
  vpc_security_group_ids  = [ aws_security_group.server.id ]
  ebs_optimized           = true
  key_name                = aws_key_pair.vpc_public_key.key_name
  iam_instance_profile    = aws_iam_instance_profile.server.name
  user_data               = file("server-start.sh")

  root_block_device {
    volume_type = "gp3"
    volume_size = 50
    encrypted   = true

    tags = {
      Instance    = "hokify server"
      Volume      = "root"
    }

  }

  tags = {
    Name = "hokify server"
  }

}


