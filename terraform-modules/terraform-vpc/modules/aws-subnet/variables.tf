variable "private_subnet_tags" {
    description = "The tags for internal subnets"
    type = map(string)
}

variable "public_subnet_tags" {
    description = "The tags for external subnets"
    type = map(string)
}

variable "vpc_id" {
    description = "The vpc_id to associate the subnet with"
    type = string

}

variable "private_subnets" {
    description = "A map of private subnets to create"
    type = map(object({
      cidr_block = string
      availability_zone = string
      enable_nat_gw = bool
      lb_association = bool
  }))
}

variable "public_subnets" {
    description = "A map of public subnets to create"
    type = map(object({
      cidr_block = string
      availability_zone = string
      lb_association = bool
  }))
}