# Creating a the default keypair for the new VPC and uploading it to S3

resource "tls_private_key" "ec2_keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "vpc_public_key" {
  key_name   = "hokify keypair"
  public_key = tls_private_key.ec2_keypair.public_key_openssh

  tags = {
    Name        = "hokify keypair"
  }
}

resource "aws_ssm_parameter" "keypair_public" {
  name        = "hokify-keypair-public"
  description = "Publicy key"
  type        = "SecureString"
  value       = tls_private_key.ec2_keypair.public_key_pem

  tags = {
    Name = "hokify-keypair-public"
  }
}

resource "aws_ssm_parameter" "keypair_private" {
  name        = "hokify-keypair-private"
  description = "Private key"
  type        = "SecureString"
  value       = tls_private_key.ec2_keypair.private_key_pem

  tags = {
    Name = "hokify-keypair-public"
  }
}
