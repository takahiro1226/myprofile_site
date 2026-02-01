# ==========================================
# Variables for Profile Site
# ==========================================

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the profile site (e.g., takahiro-work.click)"
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN of the ACM certificate (must be in us-east-1 for CloudFront)"
}

variable "project_name" {
  type        = string
  description = "Project name for resource naming"
  default     = "myprofile"
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., production, staging)"
  default     = "production"
}

variable "region" {
  type        = string
  description = "AWS Region"
  default     = "ap-northeast-1"
}
