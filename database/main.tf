resource "random_string" "password" {
  length           = 16
  special          = true
  override_special = "~!#$^&*"
}

resource "random_id" "identifier" {
  byte_length = 8
}

resource "aws_db_subnet_group" "database" {
  subnet_ids = var.subnets
  tags       = var.tags
}

data "aws_iam_policy_document" "database" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["monitoring.rds.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "database" {
  assume_role_policy = data.aws_iam_policy_document.database.json
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "policy" {
  role       = aws_iam_role.database.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_db_instance" "database" {
  engine         = "postgres"
  engine_version = var.engine_version
  instance_class = var.instance_type
  username       = var.username
  password       = random_string.password.result

  storage_type      = "gp2"
  allocated_storage = var.storage_size

  storage_encrypted               = true
  allow_major_version_upgrade     = true
  auto_minor_version_upgrade      = true
  deletion_protection             = var.deletion_protection
  monitoring_interval             = 60
  backup_retention_period         = 5
  backup_window                   = "07:00-09:00"
  maintenance_window              = "Mon:00:00-Mon:03:00"
  enabled_cloudwatch_logs_exports = ["postgresql"]
  monitoring_role_arn             = aws_iam_role.database.arn
  final_snapshot_identifier       = random_id.identifier.hex
  db_subnet_group_name            = aws_db_subnet_group.database.name
  vpc_security_group_ids          = var.security_groups
  publicly_accessible             = var.publicly_accessible
  skip_final_snapshot             = var.skip_final_snapshot

  lifecycle {
    ignore_changes = [engine_version]
  }
}
