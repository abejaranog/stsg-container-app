variable "region" {
  type        = string
  description = "AWS Region to deploy infrastructure on it"
}

variable "subnet_count" {
  type        = number
  description = "Number of subnets to deploy in each tier"
}

variable "environment" {
  type = string
}

variable "ecs_task_cpu"{
  type = number
}

variable "ecs_task_memory"{
  type = number
}

variable "docker_image"{
  type = string
}

variable "rds_db_name"{
  type = string
}

variable "rds_username" {
  type = string
}

variable "rds_port" {
  type = string
  default = "5432"
}

variable "postgres_engine_version"{
  type = string
  default = "14.4"
}

variable "rds_instance_class"{
  type = string
  default = "db.t3.micro"
}