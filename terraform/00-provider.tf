# ==========================================
# Terraform and Provider Configuration
# ==========================================

terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
  }

  # S3 Backend Configuration
  # NOTE: コメントアウトして初回terraform applyを実行し、
  # S3バケット作成後にコメントを外してterraform init -migrateを実行してください
  # backend "s3" {
  #   bucket = "myprofile-tfstate-662478938633"
  #   key    = "myprofile/terraform.tfstate"
  #   region = "ap-northeast-1"
  # }
}

# ==========================================
# AWS Provider Configuration
# ==========================================

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# CloudFront用 ACM certificates in us-east-1
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

# ==========================================
# Data Sources
# ==========================================

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ==========================================
# Local Variables
# ==========================================

locals {
  account_id  = data.aws_caller_identity.current.account_id
  region      = data.aws_region.current.id
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
