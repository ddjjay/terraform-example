
variable "igw_tags" {
  description = "The tags internet gateway"
  type = map(string)
}

variable "vpc_id" {
    description = "Sets the VPC id"
    type = string
}

variable "vpc_default_route_id" {
  description = "Sets the default VPC route id"
  type = string
}

variable "igw_route_table_id" {
    description = "A string that defines the nat route table"
    type = string
}

variable "public_subnets" {
    description = "A map containing subnet data"
    type = map(any)
}