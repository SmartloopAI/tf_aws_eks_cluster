data "aws_iam_account_alias" "this" {}

data "aws_availability_zones" "this" {
  state = "available"
}

data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = [data.aws_iam_account_alias.this.account_alias]
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  tags = {
    "type" = "private"
  }
}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.this.id]
  }
  tags = {
    "type" = "public"
  }
}

