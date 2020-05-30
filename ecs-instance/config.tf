data "aws_region" "current" {}

data "template_file" "cloud_config" {
  template = file("${path.module}/files/cloud-config.yaml")

  vars = {
    eip              = aws_eip.ip.id
    region           = data.aws_region.current.name
    ebs_volume       = aws_ebs_volume.persistent.id
    ecs_cluster_name = var.ecs_cluster_name
    iam_group        = var.iam_group
  }
}

data "template_cloudinit_config" "cloud_config" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/cloud-config"
    content      = data.template_file.cloud_config.rendered
  }
}
