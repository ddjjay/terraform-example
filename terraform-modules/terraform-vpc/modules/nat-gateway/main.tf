locals {
  tags = var.nat-gateway-tags
  enabled_nat_subnets = { for k, v in var.private_subnets : k => v if v.enable_nat_gw }
}

resource "aws_eip" "eip" {
    domain = "vpc"
    lifecycle {
      create_before_destroy = true
    }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = var.subnet_id

  tags = local.tags

  depends_on = [aws_eip.eip]
}

resource "aws_route" "nat_gw_default_route" {
  route_table_id = var.nat_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "nat_rt_association" {
  for_each      = local.enabled_nat_subnets
  subnet_id     = each.value.id
  route_table_id = var.nat_route_table_id
}