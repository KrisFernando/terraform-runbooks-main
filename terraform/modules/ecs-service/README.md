# Terraform ECS Cluster Module

## Input Variables

- project_name: string | ex. "project-name"
- environment: string | ex. "dev"
- vpc_id: string | ex. "id"
- public_subnet_ids: string array | ex. ["id", "id"]
- private_subnet_ids: string array | ex. ["id", "id"]
- cluster_id: string | ex. "id"
- cluster_name: string | ex. "cluster"
- alb_port: integer | ex. 80
- alb_security_group_id: string | ex. "id"
- app_security_group_id: string | ex. "id"
- image_tag: string | ex. "id"
- desired_count: integer | ex. 3
- container_port: integer | ex. 80
- health_check_path: string | ex. "/ecs-health"
- cpu: integer | ex. 1
- memory: integer | ex. 2
- container_environment_variables

## Output Variables

- alb_dns_name
- ecr_repository_url
- ecr_repository_arn
- ecs_service_arn
- ecs_task_definition_arn
