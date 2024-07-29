
output "private_subnets_output" {
    value = flatten(module.aws_subnets[0].private-subnet-ids.*)
}

output "public_subnets_output" {
    value = flatten(module.aws_subnets[0].public-subnet-ids.*)
}

output "vpc_id" {
  value = aws_vpc.main.id
}
