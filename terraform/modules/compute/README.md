# Terraform Compute Module

## Input Variables

- environment: string | ex. "dev"
- project_name: string | ex. "project-name"
- vpc_cidr_block: string | ex. "172.31.0.0/16"
- subnet_ids: string array | ex. ["172.31.0.0/24", "172.31.1.0/24"]
- alb_security_group_id: string | ex. "alb-nsg-id"
- instance_security_group_ids = string array | ex. ["security_group_id"]
- instance_type = string | ex. "t3.medium"
- desired_capacity = integer | ex. 4
- max_size = integer | ex. 2
- min_size = integer | ex. 12
- health_check_path = string | ex. "/ecs-health"
- container_port = integer | ex. 80

## Output Variables

- alb_dns_name
- alb_arn
- target_group_arn
- asg_name
- asg_arn
