# Terraform Security Group Module

## Input Variables

- vpc_id: string | ex. "vpc-01b3ad0d5312395ea"
- project_name: string | ex. "project-name"
- environment: string | ex. "dev"

## Output Variables

- alb_security_group_id
- ecs_task_security_group_id
