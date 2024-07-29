variable "route_table_tags" {
    description = "Set the tags for the module"
    type = map(string)
}

variable "vpc_id" {
    description = "Sets the VPC id"
    type = string
}
