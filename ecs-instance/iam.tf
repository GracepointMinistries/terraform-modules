data "aws_iam_policy_document" "instance-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "instance" {
  assume_role_policy = data.aws_iam_policy_document.instance-role.json

  tags = var.tags
}

data "aws_iam_policy_document" "instance" {
  statement {
    actions = [
      "ec2:CreateTags",
      "ec2:AssociateAddress",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:DescribeVolumes",
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "iam:GetGroup",
      "iam:GetUser",
      "iam:GetSSHPublicKey",
      "iam:ListSSHPublicKeys",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "instance" {
  path   = "/"
  policy = data.aws_iam_policy_document.instance.json
}

resource "aws_iam_role_policy_attachment" "instance" {
  role       = aws_iam_role.instance.id
  policy_arn = aws_iam_policy.instance.arn
}

resource "aws_iam_role_policy_attachment" "instance-ecs" {
  role       = aws_iam_role.instance.id
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "instance-cloudwatch" {
  role       = aws_iam_role.instance.id
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

resource "aws_iam_instance_profile" "instance" {
  role = aws_iam_role.instance.name
}
