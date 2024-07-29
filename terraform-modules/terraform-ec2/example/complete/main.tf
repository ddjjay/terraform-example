locals {
  elb_tags = merge({Name = "${var.name}-elb}"}, var.elb_tags)
  ec2_tags = var.ec2_tags
}

module "elb_security_group" {
  source = "../terraform-aws-security-group-external"

  name        = "${var.name}-elb"
  description = "Security group with access outside"
  vpc_id      = module.vpc_state.vpc_remote_output

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
  vpc_id      = module.vpc_state.vpc_remote_output

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
  vpc_id      = module.vpc_state.vpc_remote_output

  ingress_with_source_security_group_id = [
    {
      from_port                = 443
      to_port                  = 443
      protocol                 = "tcp"
      description              = "webapp"
      source_security_group_id = module.elb_security_group.security_group_id
    },
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
  vpc_id      = module.vpc_state.vpc_remote_output

  ingress_with_source_security_group_id = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      description              = "webapp"
      source_security_group_id = module.webapp_security_group.security_group_id
    },
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]

  tags = var.elb_tags
}

module "elb" {
  source = "./modules/ec2-elb"

  name    = "${var.name}-elb"
  elb_subnets = [module.vpc_state.vpc_subnet_output, module.vpc_state.vpc_private_subnet_output]
  instance_ids = flatten(module.ec2_instances.*.instance_ids)
  security_groups = [ module.elb_security_group.security_group_id ]
  elb_ports = var.elb_ports

  ec2_elb_tags = {
      Environment = "Development"
      Project     = "Example"
    }
  depends_on = [ module.ec2_instances ]
}

module "vpc_state" {
  source = "./modules/vpc-state"
  backend_config_path = "../terraform-vpc/terraform.tfstate.d/fortis-ca-central-1-web-app-dev/terraform.tfstate"
}

module "ec2_instances" {
  count = var.enable_ec2_instances ? 1 : 0
  source = "./modules/ec2-instances"  # Adjust the path according to your directory structure

  instance_count = 1
  ami_id         = "ami-08b15f43c63a1a59b"
  instance_type  = "t2.micro"
  vpc_id = module.vpc_state.vpc_remote_output
  subnet_id = module.vpc_state.vpc_private_subnet_output
  security_group_ids = [module.webapp_security_group.security_group_id]
  name = var.name
  key_name = "web-app" # The Instance pem key

  ec2_tags = local.ec2_tags
}
