locals {
  environment = terraform.workspace
  environment_config = {
    "default"     = { instance_type = "t3.medium", desired_capacity = 1, min_size = 1, max_size = 1, az = 1 }
    "development" = { instance_type = "t3.medium", desired_capacity = 2, min_size = 2, max_size = 4, az = 2  }
    "production"  = { instance_type = "t3.large", desired_capacity = 6, min_size = 6, max_size = 12, az = 3 }
  }
  current_env_settings = local.environment_config[terraform.workspace]
  instance_type = local.current_env_settings.instance_type
  desired_capacity = local.current_env_settings.desired_capacity
  min_size = local.current_env_settings.min_size
  max_size = local.current_env_settings.max_size
  region = "us-east-1"
  az = ["a", "b", "c"]
  availability_zones = [for i in range(local.current_env_settings.az) : "${local.region}${local.az[i]}"]
  cidr_block = "172.31.0.0/16"
  public_subnets = [ for i in range(local.current_env_settings.az) : cidrsubnet(local.cidr_block, 8, i) ]
  private_subnets = [ for i in range(local.current_env_settings.az) : cidrsubnet(local.cidr_block, 8, i + local.current_env_settings.az) ]
}