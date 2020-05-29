data "aws_elb_service_account" "aws" {}

resource "aws_s3_bucket" "logs" {
  bucket_prefix = var.load_balancer_bucket_prefix
  acl           = "private"
  force_destroy = var.force_destroy_bucket

  lifecycle_rule {
    enabled = true

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }

  tags = var.tags
}

data "aws_iam_policy_document" "logs" {
  statement {
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.logs.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.aws.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "logs" {
  bucket = aws_s3_bucket.logs.bucket
  policy = data.aws_iam_policy_document.logs.json
}

resource "aws_s3_bucket_public_access_block" "logs" {
  bucket = aws_s3_bucket.logs.id

  # Block new public ACLs and uploading public objects
  block_public_acls = true
  # Retroactively remove public access granted through public ACLs
  ignore_public_acls = true
  # Block new public bucket policies
  block_public_policy = true
  # Retroactivley block public and cross-account access if bucket has public policies
  restrict_public_buckets = true

  # avoid race conditions between modifications of bucket policy
  depends_on = [aws_s3_bucket_policy.logs]
}
