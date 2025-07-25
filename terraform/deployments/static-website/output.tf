# Outputs
output "cloudfront_distribution_id" {
  description = "CloudFront Distribution ID"
  value       = module.website.id
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = module.website.domain_name
}