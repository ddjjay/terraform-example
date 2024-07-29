locals {
  elb_tags = merge({Name = "${var.name}-elb}"}, var.elb_tags)
  ec2_tags = var.ec2_tags
  # Flatten the data from subnet output from VPC state
  flattened_private_subnets = merge([
    for subnet_map in module.vpc_state.private_subnets_output : {
      for k, v in subnet_map : k => {
        availability_zone = v.availability_zone
        cidr_block        = v.cidr_block
        enable_nat_gw     = v.enable_nat_gw
        id                = v.id
        lb_association    = v.lb_association
      }
    }
  ]...)
  flattened_public_subnets = merge([
    for subnet_map in module.vpc_state.public_subnets_output : {
      for k, v in subnet_map : k => {
        availability_zone = v.availability_zone
        cidr_block        = v.cidr_block
        id                = v.id
        lb_association    = v.lb_association
      }
    }
  ]...)

  enabled_lb_private_subnets = {
    for k, v in local.flattened_private_subnets : k => v if v.lb_association
  }
  enabled_lb_public_subnets = {
    for k, v in local.flattened_public_subnets : k => v if v.lb_association
  }

  enabled_lb_subnets = concat(
    [for k, v in local.enabled_lb_public_subnets : v.id], 
    [for k, v in local.enabled_lb_private_subnets : v.id]
  )
}

module "elb_security_group" {
  source = "../terraform-aws-security-group-external"

  name        = "${var.name}-elb"
  description = "Security group with access outside"
  vpc_id      = module.vpc_state.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "http-web"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]

  tags = var.elb_tags
}

module "bastion_security_group" {
  source = "../terraform-aws-security-group-external"

  name        = "${var.name}-bastion"
  description = "Security group with access outside"
  vpc_id      = module.vpc_state.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh-web"
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]

  tags = var.elb_tags
}

module "webapp_security_group" {
  source = "../terraform-aws-security-group-external"

  name        = "${var.name}-webapp"
  description = "Security group with access outside"
  vpc_id      = module.vpc_state.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 80
      to_port                  = 80
      protocol                 = "tcp"
      description              = "webapp"
      source_security_group_id = module.elb_security_group.security_group_id
    },
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      description              = "ssh-webapp"
      source_security_group_id = module.bastion_security_group.security_group_id
    }
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]

  tags = var.elb_tags
}

module "mysql_security_group" {
  source = "../terraform-aws-security-group-external"

  name        = "${var.name}-mysql"
  description = "Security group with access outside"
  vpc_id      = module.vpc_state.vpc_id

  ingress_with_source_security_group_id = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      description              = "webapp"
      source_security_group_id = module.webapp_security_group.security_group_id
    },
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      description              = "ssh"
      source_security_group_id = module.webapp_security_group.security_group_id
    },
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]

  tags = var.elb_tags
}

module "elb" {
  source = "../terraform-ec2/modules/ec2-elb"

  name    = "${var.name}-elb"
  elb_subnets = local.enabled_lb_subnets
  instance_ids = flatten(module.web_app_ec2_instances.*.instance_ids)
  security_groups = [ module.elb_security_group.security_group_id ]
  elb_ports = var.elb_ports

  ec2_elb_tags = {
      Environment = "Development"
      Project     = "Example"
    }
  depends_on = [ module.web_app_ec2_instances ]
}

module "vpc_state" {
  source = "../terraform-ec2/modules/vpc-state"
  backend_config_path = var.backend_config_path
}

module "web_app_ec2_instances" {
  count = var.enable_ec2_instances ? 1 : 0
  source = "../terraform-ec2/modules/ec2-instances"  # Adjust the path according to your directory structure

  instance_count = 1
  ami_id         = "ami-07117708253546063"
  instance_type  = "t2.micro"
  vpc_id = module.vpc_state.vpc_id
  subnet_id = local.flattened_private_subnets.app_server_subnet.id
  security_group_ids = [module.webapp_security_group.security_group_id]
  name = var.name
  key_name = "web-app"
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
    sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
    sudo dnf install mysql80-community-release-el9-1.noarch.rpm -y
    sudo dnf install mysql-community-client -y
  EOF
  ec2_tags = local.ec2_tags
}

module "sql_ec2_instances" {
  count = var.enable_ec2_instances ? 1 : 0
  source = "../terraform-ec2/modules/ec2-instances"  # Adjust the path according to your directory structure

  name = "${var.name}-mysql"
  instance_count = 1
  ami_id         = "ami-07117708253546063"
  instance_type  = "t3.micro"
  vpc_id = module.vpc_state.vpc_id
  subnet_id = local.flattened_private_subnets.backend_server_subnet.id
  security_group_ids = [module.mysql_security_group.security_group_id]
  key_name = "web-app"
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
    sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
    sudo dnf install mysql80-community-release-el9-1.noarch.rpm -y
    sudo dnf install mysql-community-server -y
    sudo echo "bind-address = 0.0.0.0" >> /etc/my.cnf
    sudo systemctl start mysqld
    sudo systemctl enable mysqld
  EOF
  ec2_tags = local.ec2_tags
}

# TODO: These get moved to the tfvars file
module "bastion_ec2_instances" {
  count = var.enable_ec2_instances ? 1 : 0
  source = "../terraform-ec2/modules/ec2-instances"  # Adjust the path according to your directory structure

  name = "${var.name}-bastion"

  instance_count = 1
  ami_id         = "ami-07117708253546063"
  instance_type  = "t2.micro"
  vpc_id = module.vpc_state.vpc_id
  subnet_id = local.flattened_public_subnets.dmz_subnet.id
  security_group_ids = [module.bastion_security_group.security_group_id]
  associate_public_ip_address = true
  key_name = "web-app"
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo wget https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm
    sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
    sudo dnf install mysql80-community-release-el9-1.noarch.rpm -y
    sudo dnf install mysql-community-server -y
    sudo systemctl start mysqld
    sudo systemctl enable mysqld
  EOF

  ec2_tags = local.ec2_tags
}