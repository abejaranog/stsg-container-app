resource "aws_iam_role" "test_ecs_role" {
  name = "${var.environment}-test-ecs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = ["ecs.amazonaws.com", "ecs-tasks.amazonaws.com"]
        }
      },
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy" "test_ecs_policy" {
  name   = "${var.environment}-test-ecs-policy"
  role   = aws_iam_role.test_ecs_role.id
  policy = data.aws_iam_policy_document.test_ecs_policy_document.json
}

data "aws_iam_policy_document" "test_ecs_policy_document" {
  statement {
    sid = "S3FullAccess"
    actions = [
      "s3:*"
    ]

    resources = [aws_s3_bucket.test_bucket.arn]
  }
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.environment}-test-ecsTaskExecutionRole"

  assume_role_policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "ecs-tasks.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
 ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy" "ecs_secrets_policy" {
  name   = "${var.environment}-secrets-ecs-policy"
  role   = aws_iam_role.ecs_task_execution_role.id
  policy = data.aws_iam_policy_document.secrets_ecs_policy_document.json
}

data "aws_iam_policy_document" "secrets_ecs_policy_document" {
  statement {
    sid = "RDSSecretAccess"
    actions = [
      "ssm:GetParameters"
    ]
    resources = [aws_ssm_parameter.rds_password.arn]
  }
}