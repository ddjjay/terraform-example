output "nat_route_table_id" {
    value = aws_route_table.nat_route_table.id
}

output "igw_route_table_id" {
    value = aws_route_table.igw_route_table.id
}
