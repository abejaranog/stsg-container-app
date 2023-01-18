resource "aws_db_instance" "test_rds" {
  tags                   = merge(local.common_tags, { Name = "test-rds" })
  db_name                = var.rds_db_name
  identifier             = "${var.environment}-test-rds"
  allocated_storage      = 10
  max_allocated_storage  = 25
  db_subnet_group_name   = aws_db_subnet_group.test_rds_subnet_group.id
  engine                 = "postgres"
  engine_version         = var.postgres_engine_version
  instance_class         = var.rds_instance_class
  username               = var.rds_username
  password               = random_password.password.result
  skip_final_snapshot    = true ## true due to test purposes
  vpc_security_group_ids = [aws_security_group.test_rds_sg.id]
  deletion_protection    = false ## false due to test purposes
}

resource "aws_db_subnet_group" "test_rds_subnet_group" {
  name       = "${var.environment}-test-rds-subnet-group"
  subnet_ids = data.aws_subnets.private_subnets.ids

  tags = merge(local.common_tags, {
    Name = "${var.environment}-test-rds-subnet-group"
  })
}

resource "random_password" "password" {
  length  = 16
  special = false
}

resource "aws_ssm_parameter" "rds_password" {
  name  = "/${var.environment}/rds/password"
  type  = "SecureString"
  value = random_password.password.result

  tags = {
    environment = var.environment
  }
}

resource "aws_security_group" "test_rds_sg" {
  name        = "${var.environment}-test-rds-sg"
  description = "Allow Inbound traffic over VPC"
  vpc_id      = data.aws_vpc.sandbox_vpc[0].id

  ingress {
    description = "Postgres connection over VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.sandbox_vpc[0].cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.common_tags, {
    Name = "${var.environment}-test-rds-sg"
  })
}