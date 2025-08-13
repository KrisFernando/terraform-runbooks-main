# Terraform ECS Cluster Module

## Input Variables

- project_name: string | ex. "project-name"
- environment: string | ex. "dev"
- vpc_id
- public_subnet_ids
- private_subnet_ids
- cluster_id
- cluster_name
- alb_port
- alb_security_group_id
- app_security_group_id
- image_tag
- desired_count
- container_port
- health_check_path
- cpu
- memory
- container_environment_variables

## Output Variables

- alb_dns_name
- ecr_repository_url
- ecr_repository_arn
- ecs_service_arn
- ecs_task_definition_arn
