# modules/ecs-service/main.tf
# This module defines the resources for a specific web application,
# including ECR, ECS Task Definition, ECS Service, and an ALB.

# ECR Repository for the application images
resource "aws_ecr_repository" "app_repo" {
  name                 = "ecr-${var.app_name}-${var.environment}" 
  image_tag_mutability = "IMMUTABLE" 

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = "ecr-${var.app_name}-${var.environment}"
    Environment = var.environment
  }
}

# IAM Role for ECS Task Execution (Fargate requires this for logging, ECR pull, etc.)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role-${var.app_name}-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# IAM Role for ECS Task (if your application needs AWS permissions, e.g., S3 access)
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role-${var.app_name}-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
}

# Attach policies to ecs_task_role as needed (e.g., S3 read-only, DynamoDB access)
/*
resource "aws_iam_role_policy_attachment" "app_s3_read_policy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}
*/

# ECS Task Definition
resource "aws_ecs_task_definition" "app_task" {
  family                   = "${var.app_name}-${var.environment}"
  cpu                      = var.cpu
  memory                   = var.memory
  requires_compatibilities = ["EC2"]
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name        = var.app_name
      image       = "${aws_ecr_repository.app_repo.repository_url}:${var.image_tag}"
      cpu         = var.cpu
      memory      = var.memory
      essential   = true
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = 0
          protocol      = "tcp"
        }
      ]
      environment = var.container_environment_variables # Pass environment variables
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.app_name}-${var.environment}"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
    }
  ])

  tags = {
    Name        = "task-def-${var.app_name}-${var.environment}"
    Environment = var.environment
  }
}

# CloudWatch Log Group for ECS tasks
resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/ecs/${var.app_name}-${var.environment}"
  retention_in_days = 7 # Adjust as needed

  tags = {
    Name        = "log-group-${var.app_name}-${var.environment}"
    Environment = var.environment
  }
}

# Application Load Balancer
resource "aws_lb" "app_alb" {
  name               = "alb-${var.app_name}-${var.environment}"
  internal           = false # Public-facing ALB for websites
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id] # Security group for ALB
  subnets            = var.public_subnet_ids # ALB needs to be in public subnets

  tags = {
    Name        = "alb-${var.app_name}-${var.environment}"
    Environment = var.environment
  }
}

# ALB Target Group 
resource "aws_lb_target_group" "app_tg" {
  name        = "tg-${var.app_name}-${var.environment}"
  port        = var.alb_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance" 

  health_check {
    path                = var.health_check_path
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name        = "tg-${var.app_name}-${var.environment}"
    Environment = var.environment
  }
}

# ALB Listener (HTTP on port 80)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = var.alb_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.app_tg.arn
    type             = "forward"
  }

  tags = {
    Name        = "alb-listener-http-${var.app_name}-${var.environment}"
    Environment = var.environment
  }
}

# ECS Service
resource "aws_ecs_service" "app_service" {
  name            = "ecs-service-${var.app_name}-${var.environment}"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = var.desired_count
  launch_type     = "EC2"

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = var.app_name
    container_port   = var.container_port
  }

  # Optional: Deployment circuit breaker for better deployments
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  # Optional: Deployment controller type
  deployment_controller {
    type = "ECS" 
  }

  tags = {
    Name        = "ecs-service-${var.app_name}-${var.environment}"
    Environment = var.environment
  }

  # Ensure the service waits for the ALB and Target Group to be ready
  depends_on = [
    aws_lb_listener.http,
    aws_iam_role_policy_attachment.ecs_task_execution_role_policy,
  ]
}