variable "name" {
  description = "The name used for the VPC"
  type = string
}

variable "elb_subnets" {
    description = "A list of subnets to attach the elb"
    type = list(string)
}

variable "security_groups" {
    description = "A list of security groups assigned to the elb"
    type = list(string)
}

variable "instance_ids" {
    description = "A list of instanceids to send traffic to"
    type = list(string)
    default = []
}

# variable "elb_ports" {
#   description = "A map that contains elb port information"
#   type = map(object(
#     {
#         instance_port     = number
#         instance_protocol = string
#         lb_port           = number
#         lb_protocol       = string
#     }))
#   default = {}
# }

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
  ]
}

variable "ec2_elb_tags" {
  description = "A map containing tags for the elb"
  type = map(string)
}