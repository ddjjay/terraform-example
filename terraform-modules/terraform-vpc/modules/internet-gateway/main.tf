locals {
    tags = var.igw_tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = local.tags
}

resource "aws_route" "igw_default_route" {
  route_table_id         = var.igw_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "igw_rt_association" {
  for_each      = var.public_subnets
  #{ for subnet in var.public_subnets : subnet.id => subnet }
  subnet_id     = each.value.id
  route_table_id = var.igw_route_table_id
}