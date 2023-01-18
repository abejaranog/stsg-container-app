resource "aws_ecs_cluster" "test" {
  name = "${var.environment}-test-ecs-cluster"
  tags = local.common_tags
}

resource "aws_ecs_task_definition" "test_app" {
  family                   = "${var.environment}-test-app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.test_ecs_role.arn
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
  container_definitions = jsonencode([
    {
      name      = "app"
      image     = var.docker_image
      cpu       = var.ecs_task_cpu
      memory    = var.ecs_task_memory
      essential = true
      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
        }
      ]
      environment = [
        { "name" : "DJANGO_SETTINGS_MODULE", "value" : "iotd.settings" },
        { "name" : "RDS_DB_NAME", "value" : var.rds_db_name },
        { "name" : "RDS_USERNAME", "value" : var.rds_username },
        { "name" : "RDS_HOSTNAME", "value" : aws_db_instance.test_rds.address },
        { "name" : "RDS_PORT", "value" : var.rds_port },
        { "name" : "S3_BUCKET_NAME", "value" : aws_s3_bucket.test_bucket.id }
      ]
      secrets = [
        {
          "name" : "RDS_PASSWORD",
          "valueFrom" : aws_ssm_parameter.rds_password.arn
        }
      ]
    }
  ])
  tags = local.common_tags
}

resource "aws_ecs_service" "test_service" {
  name            = "${var.environment}-test-service"
  cluster         = aws_ecs_cluster.test.id
  task_definition = aws_ecs_task_definition.test_app.arn
  desired_count   = 1
  depends_on      = [aws_iam_role_policy.test_ecs_policy]
  launch_type     = "FARGATE"
  network_configuration {
    security_groups  = [aws_security_group.test_ecs_sg.id]
    subnets          = data.aws_subnets.public_subnets.ids
    assign_public_ip = true
  }
  tags = local.common_tags
}


resource "aws_security_group" "test_ecs_sg" {
  name        = "${var.environment}-test-ecs-sg"
  description = "Allow Inbound traffic over"
  vpc_id      = data.aws_vpc.sandbox_vpc[0].id

  ingress {
    description = "App connection"
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-test-ecs-sg"
  })
}