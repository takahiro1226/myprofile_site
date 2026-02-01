# ==========================================
# CloudFront Distribution
# ==========================================

# ------------------------------------------
# CloudFront Origin Access Control (OAC)
# ------------------------------------------

resource "aws_cloudfront_origin_access_control" "main" {
  name                              = "${var.project_name}-oac"
  description                       = "OAC for ${var.project_name} S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

# ------------------------------------------
# CloudFront Distribution
# ------------------------------------------

resource "aws_cloudfront_distribution" "main" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for ${var.domain_name}"
  default_root_object = "index.html"
  price_class         = "PriceClass_200" # US, Europe, Asia, Middle East, and Africa
  aliases             = [var.domain_name]

  # Origin configuration (S3 bucket)
  origin {
    domain_name              = aws_s3_bucket.content.bucket_regional_domain_name
    origin_id                = "S3-${aws_s3_bucket.content.id}"
    origin_access_control_id = aws_cloudfront_origin_access_control.main.id
  }

  # Default cache behavior
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.content.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600  # 1 hour
    max_ttl                = 86400 # 24 hours
    compress               = true
  }

  # Cache behavior for CSS files
  ordered_cache_behavior {
    path_pattern     = "css/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.content.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400  # 24 hours
    max_ttl                = 604800 # 7 days
    compress               = true
  }

  # Cache behavior for images
  ordered_cache_behavior {
    path_pattern     = "img/*"
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.content.id}"

    forwarded_values {
      query_string = false
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400  # 24 hours
    max_ttl                = 604800 # 7 days
    compress               = true
  }

  # SSL/TLS certificate configuration
  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  # Geo restriction (none by default)
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # Custom error responses
  custom_error_response {
    error_code         = 403
    response_code      = 404
    response_page_path = "/index.html"
  }

  custom_error_response {
    error_code         = 404
    response_code      = 404
    response_page_path = "/index.html"
  }

  tags = merge(
    local.common_tags,
    {
      Name        = "${var.project_name}-cloudfront"
      Description = "CloudFront distribution for ${var.domain_name}"
    }
  )
}