# ==========================================
# Route 53 DNS Configuration
# ==========================================

# ------------------------------------------
# Data Source: Existing Hosted Zone
# ------------------------------------------

data "aws_route53_zone" "main" {
  name         = var.domain_name
  private_zone = false
}

# ------------------------------------------
# Route 53 Records (A and AAAA)
# ------------------------------------------

# A Record (IPv4) - Alias to CloudFront
resource "aws_route53_record" "a" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = false
  }
}

# AAAA Record (IPv6) - Alias to CloudFront
resource "aws_route53_record" "aaaa" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "AAAA"

  alias {
    name                   = aws_cloudfront_distribution.main.domain_name
    zone_id                = aws_cloudfront_distribution.main.hosted_zone_id
    evaluate_target_health = false
  }
}
