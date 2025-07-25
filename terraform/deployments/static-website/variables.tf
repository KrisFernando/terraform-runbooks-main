# modules/static-website/variables.tf
variable "aws_region" {
  description = "AWS region for the deployment."
  type        = string
  default = "us-east-1"
}

variable "bucket_name" {
  description = "The name of the S3 bucket."
  type        = string
}

variable "domain_name" {
  description = "The domain name for the website (e.g., example.com)"
  type        = string
}

variable "subdomain" {
  description = "Subdomain for the website (e.g., www). Leave empty for apex domain"
  type        = string
  default     = "www"
}

variable "certificate_arn" {
  description = "Certificate ARN for the website"
  type        = string
}

variable "github_organization" {
  description = "The name of the Organization."
  type        = string
  default = "Organization"
}

variable "github_repository" {
  description = "The name of the Repository."
  type        = string
  default = "Repository"
}