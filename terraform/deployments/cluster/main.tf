# runbooks/cluster/main.tf
# This module orchestrates the deployment of a complete ECS environment,
# including VPC, subnets, internet gateway, NAT gateways, security groups,
# the ECS cluster itself, and optionally Auto Scaling Group/Load Balancer
# for EC2 container instances.

# Call the network module to set up VPC, subnets, etc.
module "network" {
  source = "git::https://github.com/org-name/terraform-network-module.git?ref=v1.0.0"

  environment        = local.environment
  project_name       = var.project_name
  vpc_cidr_block     = local.cidr_block
  public_subnets     = local.public_subnets
  private_subnets    = local.private_subnets
  availability_zones = local.availability_zones
}

module "ecs_container_asg_alb" {
  source = "git::https://github.com/org-name/terraform-compute-module.git?ref=v1.0.0"

  environment          = local.environment
  project_name         = var.project_name
  vpc_id               = module.network.vpc_id
  subnet_ids           = module.network.private_subnet_ids # Or public, depending on architecture
  alb_security_group_id = module.common_security_groups.alb_security_group_id
  instance_security_group_ids = [module.common_security_groups.ecs_task_security_group_id] # Example SG output
  instance_type        = local.instance_type
  desired_capacity     = local.desired_capacity
  max_size             = local.max_size
  min_size             = local.min_size
  health_check_path    = "/ecs-health" # Health check for ECS agent
  container_port       = 80 # Or relevant port for ECS agent
}

# Call the security group module for common security groups.
module "common_security_groups" {
  source = "git::https://github.com/org-name/terraform-security-group-module.git?ref=v1.0.0"

  vpc_id      = module.network.vpc_id
  project_name = var.project_name
  environment = local.environment
}

# Call the ECS cluster module to create the ECS cluster resource.
module "ecs_cluster" {
  source = "git::https://github.com/org-name/terraform-ecs-cluster-module.git?ref=v1.0.0"

  project_name = var.project_name
  environment  = local.environment
}

module "github_provider" {
  source = "git::https://github.com/org-name/terraform-github-oidc-provider-module.git?ref=v1.0.0"

  project_name = var.project_name
  environment = local.environment
}