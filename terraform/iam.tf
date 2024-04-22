resource "aws_iam_instance_profile" "server" {
  name = "hokify-server"
  role = aws_iam_role.server.name
}

resource "aws_iam_role" "server" {
  name = "hokify-server"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "server" {
  role       = aws_iam_role.server.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
