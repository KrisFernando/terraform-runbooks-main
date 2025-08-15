# modules/cluster/variables.tf
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

