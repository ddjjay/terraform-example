# We return a list of subnets created
output "private-subnet-ids" {
  value = { for k, subnet in aws_subnet.private : k => {
      id = subnet.id
      cidr_block = subnet.cidr_block
      availability_zone = subnet.availability_zone
      enable_nat_gw = tobool(subnet.tags_all.enable_nat_gw)
      lb_association = tobool(subnet.tags_all.lb_association)
    } 
  }
  description = "We return the list of subnets created"
}

# We return a list of subnets created
output "public-subnet-ids" {
  value = { for k, subnet in aws_subnet.public : k => {
      id = subnet.id
      cidr_block = subnet.cidr_block
      availability_zone = subnet.availability_zone
      lb_association = tobool(subnet.tags_all.lb_association)
    } 
  }
}

# added to mock creation during testing
# output "public_subnet_ids" {
#   value = {
#     "alb_subnet" = {
#       id = "subnet-12345",
#       cidr_block = "10.10.1.0/24",
#       availability_zone = "us-west-2a"
#     }
#   }
#   description = "Mocked output for testing purposes."
# }