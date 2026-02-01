# ==========================================
# Terraform Outputs
# ==========================================

# ------------------------------------------
# S3 Bucket Outputs
# ------------------------------------------

output "s3_content_bucket_name" {
  description = "Name of the S3 bucket for website content"
  value       = aws_s3_bucket.content.id
}

output "s3_content_bucket_arn" {
  description = "ARN of the S3 bucket for website content"
  value       = aws_s3_bucket.content.arn
}

output "s3_tfstate_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.tfstate.id
}

output "s3_tfstate_bucket_arn" {
  description = "ARN of the S3 bucket for Terraform state"
  value       = aws_s3_bucket.tfstate.arn
}

# ------------------------------------------
# CloudFront Outputs
# ------------------------------------------

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.main.id
}

output "cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN"
  value       = aws_cloudfront_distribution.main.arn
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.main.domain_name
}

# ------------------------------------------
# Route 53 Outputs
# ------------------------------------------

output "route53_zone_id" {
  description = "Route 53 hosted zone ID"
  value       = data.aws_route53_zone.main.zone_id
}

output "route53_name_servers" {
  description = "Route 53 name servers"
  value       = data.aws_route53_zone.main.name_servers
}

# ------------------------------------------
# Website URL
# ------------------------------------------

output "website_url" {
  description = "Website URL (custom domain)"
  value       = "https://${var.domain_name}"
}

output "cloudfront_url" {
  description = "CloudFront distribution URL"
  value       = "https://${aws_cloudfront_distribution.main.domain_name}"
}

# ------------------------------------------
# Deployment Information
# ------------------------------------------

output "deployment_info" {
  description = "Deployment information for GitHub Actions"
  value = {
    s3_bucket_name            = aws_s3_bucket.content.id
    cloudfront_distribution_id = aws_cloudfront_distribution.main.id
    website_url               = "https://${var.domain_name}"
  }
}
