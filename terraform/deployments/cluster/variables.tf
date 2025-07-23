# modules/cluster/variables.tf
variable "aws_region" {
  description = "AWS region for the deployment."
  type        = string
  default = "us-east-1"
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

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC."
  type        = string
  default = "172.31.0.0/16"
}

variable "public_subnets" {
  description = "List of CIDR blocks for public subnets."
  type        = list(string)
  default = [ "172.31.0.0/24", "172.31.1.0/24", "172.31.2.0/24" ]
}

variable "private_subnets" {
  description = "List of CIDR blocks for private subnets."
  type        = list(string)
  default = [ "172.31.3.0/24", "172.31.4.0/24", "172.31.5.0/24" ]  
}

variable "availability_zones" {
  description = "List of availability zones to use."
  type        = list(string)
  default = [ "us-east-1a", "us-east-1b", "us-east-1c" ]
}

variable "ecs_instance_type" {
  description = "The EC2 instance type for ECS container instances."
  type        = string
  default     = "t3.medium"
}

variable "ecs_desired_capacity" {
  description = "The desired number of ECS container instances in the ASG."
  type        = number
  default     = 1
}

variable "ecs_max_size" {
  description = "The maximum number of ECS container instances in the ASG."
  type        = number
  default     = 3
}

variable "ecs_min_size" {
  description = "The minimum number of ECS container instances in the ASG."
  type        = number
  default     = 1
}