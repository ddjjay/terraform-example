variable "name" {
  description = "The name used for the EC2"
  type = string
}

variable "instance_count" {
    description = "Number of EC2 instances to create"
    type        = number
}

variable "ami_id" {
    description = "A string defining the AMI Id to use"
    type        = string
}

variable "instance_type" {
    description = "A string that defines the instance type"    
    type        = string
    default = "t2.micro"
}

variable "security_group_ids" {
    description = "A list of group ids to attach to instances"    
    type        = list(string)
}

variable "subnet_id" {
    description = "A string containing the subnet_id to associate the instance"    
    type        = string
}

variable "vpc_id" {
    description = "A string containing the vpc_id to associate the instance"    
    type        = string
}

variable "associate_public_ip_address" {
    type = bool
    default = false
}

variable "ec2_tags" {
    description = "A map of strings defining the tags for the ec2 instances "
    type = map(string)
}

variable "key_name" {
    description = "A string that defines the ssh key for an instance."
    type = string
}

variable "user_data" {
  description = "A String that contains user_data"
  type = string
  default = ""
}