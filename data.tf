data "aws_subnets" "private_subnets" {
  filter {
    name   = "tag:tier"
    values = ["private"]
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "tag:tier"
    values = ["public"]
  }
}

data "aws_vpcs" "vpcs" {
  tags = {
    Owner = "devops"
  }
}

data "aws_vpc" "sandbox_vpc" {
  count = length(data.aws_vpcs.vpcs.ids)
  id    = tolist(data.aws_vpcs.vpcs.ids)[count.index]
}

data "aws_availability_zones" "azs" {
}