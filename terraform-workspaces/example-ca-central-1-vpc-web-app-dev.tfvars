
name = "web-app"
region = "ca-central-1"
profile = "default"
env = "dev"
group = "example"
git_path = "../terraform-modules/terraform-vpc" # When this is commited to Git this will be used.

#### VPC ####
# Configures the VPC, this is mandatory for now
## TODO: Add option to define existing VPC using data source
#
vpc_cidr = "10.10.0.0/16"
instance_tenancy = "default"
vpc_tags = {
    custom_vpc_tag = "custom1"
}
enable_dns_hostnames = true
enable_dns_support = true

#### AWS Subnets ####
## We set our options to enable subnets
#
# Enable subnet creation for public and private subnets
enable_subnets = true
# Set our private subnets
private_subnets = {
    frontend_server_subnet = {
        cidr_block = "10.10.2.0/24",
        availability_zone = "ca-central-1b",
        enable_nat_gw = true
        lb_association = true
    },
    backend_server_subnet = {
        cidr_block = "10.10.3.0/24",
        availability_zone = "ca-central-1d"
        enable_nat_gw = true
        lb_association = false
    }
}

#The NAT interface will attach to the subnet defined by nat_subnet_key
## Create public subnets
public_subnets = {    
    dmz_subnet = {
        cidr_block = "10.10.1.0/24",
        availability_zone = "ca-central-1a",
        lb_association = true
    }
}

# Custom tags we want to add to the private subnet
private_subnet_tags = {
    custom_private_subnet = "custom1"
}

# Custom tags we want to add to the public subnet
public_subnet_tags = {
    custom_public_subnet = "custom1"
}

#### Internet Gateway ####
# Enables the internet gateway
## We can add more options later
#
enable_igw = true
igw_tags = {
    custom_igw_tag = "custom1"
}

#### NAT Gateway ####
# The NAT interface will attach to the subnet defined by nat_subnet_key
## See above in "AWS Subnets" section public_subnets
#
enable_nat_gw = true
natgw_tags = {
    custom_natgw_tag = "custom_1"
}

# Needs to be defined if NAT Gateway is enabled
nat_subnet_key = "dmz_subnet"

#### Routes ####
# Right now we just process all private subnets to access nat gateway,
## We can add idexes and more logic another time.
#
enable_nat_gw_routes = true

##### ELB

elb_ports = [
   {
        instance_port     = 443,
        instance_protocol = "tcp",
        lb_port           = 443,
        lb_protocol       = "tcp",
        #ssl_certificate_id = ""
    }
]

####### EC2 #######

ec2_tags = {
    custom_ec2_tag = "custom1"
}