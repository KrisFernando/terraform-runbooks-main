# Terraform Network Module

## Input Variables

- environment: string | ex. "dev"
- project_name: string | ex. "project-name"
- vpc_cidr_block: string | ex. "172.31.0.0/16"
- public_subnets: string array | ex. ["172.31.0.0/24", "172.31.1.0/24"]
- private_subnets: string array | ex. ["172.31.2.0/24", "172.31.3.0/24"]
- availability_zones: string array | ex. ["us-east-1a", "us-east-1b"]

## Output Variables

- vpc_id
- public_subnet_ids
- private_subnet_ids
