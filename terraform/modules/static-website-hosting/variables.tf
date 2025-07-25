# Variables
variable "environment" {
  description = "The deployment environment (e.g., 'dev', 'prod')."
  type        = string
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
