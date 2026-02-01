# ==========================================
# S3 Buckets
# ==========================================

# Random suffix for unique bucket names
resource "random_id" "bucket_suffix" {
  byte_length = 4
}

# ------------------------------------------
# S3 Bucket for Website用コンテンツ
# ------------------------------------------

resource "aws_s3_bucket" "content" {
  bucket = "${var.project_name}-content-${random_id.bucket_suffix.hex}"

  tags = merge(
    local.common_tags,
    {
      Name        = "${var.project_name}-content"
      Description = "Static website content for profile site"
    }
  )
}

# Block all public access (CloudFront will access via OAC)
resource "aws_s3_bucket_public_access_block" "content" {
  bucket = aws_s3_bucket.content.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning for content bucket
resource "aws_s3_bucket_versioning" "content" {
  bucket = aws_s3_bucket.content.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Server-side encryption for content bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "content" {
  bucket = aws_s3_bucket.content.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Bucket policy to allow CloudFront OAC access
resource "aws_s3_bucket_policy" "content" {
  bucket = aws_s3_bucket.content.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipal"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.content.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.main.arn
          }
        }
      }
    ]
  })
}

# Lifecycle policy for content bucket (keep old versions for 30 days)
resource "aws_s3_bucket_lifecycle_configuration" "content" {
  bucket = aws_s3_bucket.content.id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

# ------------------------------------------
# S3 Bucket for Terraform State用
# ------------------------------------------

resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.project_name}-tfstate-${var.aws_account_id}"

  tags = merge(
    local.common_tags,
    {
      Name        = "${var.project_name}-tfstate"
      Description = "Terraform state file storage"
    }
  )
}

# Block all public access for tfstate bucket
resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning for tfstate bucket
resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Server-side encryption for tfstate bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Lifecycle policy for tfstate bucket (optional: keep old versions for 90 days)
resource "aws_s3_bucket_lifecycle_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    noncurrent_version_expiration {
      noncurrent_days = 90
    }
  }
}
