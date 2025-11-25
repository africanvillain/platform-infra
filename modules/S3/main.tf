##############################
# S3 BUCKET
##############################

resource "aws_s3_bucket" "this" {
  bucket = "${var.env}-${var.name}-${var.unique_suffix}"

  tags = {
    Name = "${var.env}-${var.name}-${var.unique_suffix}"
    Env  = var.env
  }
}

##############################
# BLOCK PUBLIC ACCESS
##############################

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

##############################
# VERSIONING
##############################

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

##############################
# ENCRYPTION (SSE-S3)
##############################

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

##############################
# LIFECYCLE
##############################

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    id     = "expiration-rule"
    status = "Enabled"

    filter {
      prefix = ""
    }

    expiration {
      days = var.expiration_days
    }
  }
}
