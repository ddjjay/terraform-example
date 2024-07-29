#### Workspace information ####

variable "name" {
  description = "The name used for the VPC"
  type = string
  default = "webapp"
}

variable "region" {
  description = "Set the AWS region"
  type = string
  default = "ca-central-1"
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

variable "elb_tags" {
  description = "A map of tags for the elb"
  type = map(string)
  default = {}
}

variable "vpc_id" {
  description = "The string containing the VPCid for the ec2 resources"
  type = string
  default = "vpc-53861e3b"
}

variable "elb_ports" {
  description = "List of listener configurations for the ELB"
  type = list(object({
    instance_port     = number
    instance_protocol = string
    lb_port           = number
    lb_protocol       = string
    ssl_certificate_id = optional(string)
  }))
  default = [
    {
      instance_port     = 80,
      instance_protocol = "HTTP",
      lb_port           = 8080,
      lb_protocol       = "HTTP"
    }
    # },
    # {
    #   instance_port     = 443,
    #   instance_protocol = "HTTPS",
    #   lb_port           = 443,
    #   lb_protocol       = "HTTPS",
    #   ssl_certificate_id = "arn:aws:iam::123456789012:server-certificate/your_certificate"
    # }
  ]
}

variable "enable_ec2_instances" {
  description = "A boolean value that enables/disables ec2 instances"
  type = bool
  default = true
}

variable "ec2_tags" {
    description = "A map of strings defining the tags for the ec2 instances "
    type = map(string)
}

variable "backend_config_path" {
  type = string
  default = "../terraform-vpc/terraform.tfstate.d/fortis-ca-central-1-vpc-web-app-dev/terraform.tfstate"
}

variable "state_path" {
  type = string
  default = "./terraform.tfstate.d/fortis-ca-central-1-ec2-web-app-dev/terraform.tfstate"
}
