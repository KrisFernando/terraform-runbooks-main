# runbooks/static-website/main.tf
# This module orchestrates the deployment of a static website environment,
# including S3 bucket, CloudFront Distribution, and Imported Certificate

# Define the AWS provider for this deployment.
# The region variable would be set via CLI, environment variable, or a .tfvars file.
provider "aws" {
  region = var.aws_region
}

# Configure the Terraform remote backend for state management.
# The bucket and key should be unique per environment/deployment.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.2.0"
    }
  }
  required_version = "~> 1.12.2"

  backend "s3" {
    bucket         = "tf-configuration-statefiles-2025-07-04-xasdf" # Dynamic bucket name based on environment
    key            = "domain/domain-tf-state-file.tfstate"
    region         = "us-east-1" # State bucket region (can be different from resource region)
    encrypt        = true
    use_lockfile = true
  }
}

# Call the network module to set up VPC, subnets, etc.
module "website" {
  source = "git::https://github.com/org-name/terraform-static-website-hosting.git?ref=v1.0.0"

  environment = local.environment
  bucket_name = var.bucket_name
  domain_name = var.domain_name
  subdomain = var.subdomain
  certificate_arn = var.certificate_arn

}

