resource "aws_ebs_volume" "persistent" {
  availability_zone = var.az
  size              = var.persistent_volume_size

  tags = var.tags
}

data "aws_ami" "instance" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

resource "aws_launch_configuration" "instance" {
  image_id                    = data.aws_ami.instance.id
  instance_type               = var.instance_type
  iam_instance_profile        = aws_iam_instance_profile.instance.id
  security_groups             = concat([aws_security_group.instance.id], var.security_groups)
  associate_public_ip_address = true

  user_data = data.template_cloudinit_config.cloud_config.rendered

  root_block_device {
    delete_on_termination = true
    volume_size           = var.ephemeral_volume_size
  }

  # avoid dependency of asg when recreating lc
  lifecycle {
    create_before_destroy = true
  }
}

locals {
  keys   = keys(var.tags)
  values = values(var.tags)
}

data "null_data_source" "tag_list" {
  count = length(local.keys)

  inputs = {
    key                 = local.keys[count.index]
    value               = local.values[count.index]
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "instance" {
  # this ASG is used for bringing back any instances that might terminate unexpectedly
  min_size             = 1
  desired_capacity     = 1
  max_size             = 1
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.instance.name
  vpc_zone_identifier  = [var.subnet]
  tags                 = data.null_data_source.tag_list.*.outputs
}
