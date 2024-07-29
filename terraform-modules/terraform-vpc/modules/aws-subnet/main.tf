locals {
  private_subnet_tags = var.private_subnet_tags
  public_subnet_tags = var.public_subnet_tags
}

resource "aws_subnet" "private" {
  for_each = var.private_subnets
  vpc_id     = var.vpc_id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = merge(
    {Name = "${each.key}"},
    {enable_nat_gw = "${each.value.enable_nat_gw}"},
    {lb_association = "${each.value.lb_association}"},
    local.private_subnet_tags
  )
}

resource "aws_subnet" "public" {
  for_each = var.public_subnets
  vpc_id     = var.vpc_id
  cidr_block = each.value.cidr_block
  availability_zone = each.value.availability_zone

    tags = merge(
      {Name = "${each.key}"},
      {lb_association = "${each.value.lb_association}"},
      local.public_subnet_tags
  )
}