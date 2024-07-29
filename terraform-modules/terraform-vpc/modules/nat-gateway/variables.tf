variable "nat-gateway-tags" {
    description = "Set the tags for the module"
    type = map(string)
}

variable "subnet_id" {
    description = "Use this subnet id to attach to internet gw"
    type = string
}

variable "vpc_id" {
    description = "Sets the VPC id"
    type = string
}

variable "nat_route_table_id" {
    description = "A string that defines the nat route table"
    type = string
}

variable "private_subnets" {
    description = "A map containing subnet data"
    type = map(any)
}