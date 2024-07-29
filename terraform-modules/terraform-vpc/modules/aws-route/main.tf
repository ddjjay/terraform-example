locals {
  route_table_tags = var.route_table_tags
}

resource "aws_route_table" "nat_route_table" {
    vpc_id = var.vpc_id
    tags = merge({Name = "nat_route_table"} ,local.route_table_tags)
}

resource "aws_route_table" "igw_route_table" {
    vpc_id = var.vpc_id
    tags = merge({Name = "igw_route_table"} ,local.route_table_tags)
}
