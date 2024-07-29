#### Workspace information ####

variable "name" {
  description = "The name used for the VPC"
  type = string
}

variable "region" {
  description = "Set the AWS region"
  type = string
}

variable "profile" {
  description = "Sets the AWS profile to use"
  type = string
  default = "default"
}

variable "env" {
  description = "The environment for this resource"
  type = string
  default = "dev"
}

variable "group" {
  description = "The the group that owns the resource"
  type = string
  default = "fortis"
}

##### Resources - VPC ####

variable "vpc_cidr" {
  description = "Sets the VPC cidr"
  type = string
}

variable "instance_tenancy" {
  description = "Sets the instance tennancy"
  type = string
}

variable "vpc_tags" {
  description = "Sets the tags for the VPC"
  type = map(string)
}

variable "enable_dns_hostnames" {
  description = "Boolean flag that enables/disables DNS hostnanes"
  type = bool
  default = true
}

variable "enable_dns_support" {
  description = "Boolean flag that enables/disables DNS Support"
  type = bool
  default = true
}

variable "nat_subnet_key" {
  description = "What subnet key to use public_subnets"
  type = string
}

##### Resource - IGW ######
variable "igw_tags" {
  description = "Sets the tags for the internet gateway"
  type = map(string)
}

variable "enable_igw" {
  description = "Boolean flag that enables/disables Internet Gateway"
  type = bool
  default = true
}

##### Resource - NAT Gateway ######

variable "natgw_tags" {
  description = "Sets the tags for the NAT gateway"
  type = map(string)
}

variable "enable_nat_gw" {
  description = "Boolean flag that enables/disables NAT gateway"
  type = bool
  default = true
}


##### Resource - Subnets ######

variable "enable_subnets" {
  description = "A boolean value that enables/disables creation of internal/external subnets"
  type = bool
  default = false
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

variable "private_subnet_tags" {
  description = "Map that contains custom tags for the subnet"
  type = map(string)
  default = {}
}

variable "public_subnet_tags" {
  description = "Map that contains custom tags for the subnet"
  type = map(string)
  default = {}
}

##### NAT Routes ######

variable "enable_nat_gw_routes" {
  description = "Enable private subnets routes for NAT access"
  type = bool
  default = false
}

variable "nat_route_table_tags" {
  description = "A map that contains tags for nat_gateway_routes"
  type = map(string)
  default = {}
}

#### IGW Routes ####
variable "igw_route_table_tags" {
  description = "A map of strings that contain tags"
  type = map(string)
  default = {}
}
