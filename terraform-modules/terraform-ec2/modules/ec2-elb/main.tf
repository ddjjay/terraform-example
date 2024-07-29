locals {
  ec2_elb = var.ec2_elb_tags
}

## TODO: Add more vars for healthcheck and other options

# Create a new load balancer
resource "aws_elb" "elb" {
  name               = var.name
  subnets = var.elb_subnets
  security_groups = var.security_groups

#   access_logs {
#     bucket        = "foo"
#     bucket_prefix = "bar"
#     interval      = 60
#   }

  dynamic "listener" {
      for_each = var.elb_ports
      content {
          instance_port     = listener.value.instance_port
          instance_protocol = listener.value.instance_protocol
          lb_port           = listener.value.lb_port
          lb_protocol       = listener.value.lb_protocol
          ssl_certificate_id = listener.value.ssl_certificate_id
      }
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 30
    target              = "HTTP:80/"
    interval            = 60
  }

  instances                   = var.instance_ids
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = local.ec2_elb
}