data "aws_caller_identity" "current" {}

locals {
  common_tags = {
    Owner       = "abg"
    environment = var.environment
  }
  aws_account = data.aws_caller_identity.current.account_id
}