
name = "web-app"
region = "ca-central-1"
profile = "default"
env = "dev"
group = "example"
git_path = ""

## *** Apply the VPC resources first **** ##
# TODO: Add more variables to make this stack easier to configure
## We split VPC and Compute/elb into 2 workspaces

##### ELB

elb_ports = [
   {
        instance_port     = 443,
        instance_protocol = "tcp",
        lb_port           = 443,
        lb_protocol       = "tcp",
        ssl_certificate_id = ""
    }
]

####### EC2 #######

ec2_tags = {
    custom_ec2_tag = "custom1"
}