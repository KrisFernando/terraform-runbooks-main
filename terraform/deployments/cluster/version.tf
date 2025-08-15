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
    key            = "cluster/cluster-tf-state-file.tfstate"
    region         = local.region # Dynamic region based on environment # State bucket region (can be different from resource region)
    encrypt        = true
    use_lockfile = true
  }
}