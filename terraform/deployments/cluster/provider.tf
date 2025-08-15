# Define the AWS provider for this deployment.
# The region variable would be set via CLI, environment variable, or a .tfvars file.
provider "aws" {
  region = local.region
}

# Provider for the Dev account
provider "aws" {
  alias = "dev"
  region = local.region
  assume_role {
    role_arn = "arn:aws:iam::111122223333:role/TerraformDeploymentRole"
  }
}

# Provider for the QA account
provider "aws" {
  alias = "qa"
  region = local.region
  assume_role {
    role_arn = "arn:aws:iam::444455556666:role/TerraformDeploymentRole"
  }
}