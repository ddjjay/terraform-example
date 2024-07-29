locals {
    name = var.name
    group = var.group
    region = var.region
    environment = var.env
    cwd_path = path.cwd
    
    workspace_name = "${local.group}-${local.region}-${local.name}-${local.environment}"
    workspace_path = "..\\${local.cwd_path}\\${local.group}-terraform-workspaces\\${local.workspace_name}"

    vpc_tags = merge({Name="${var.name}-vpc"}, var.vpc_tags)
    igw_tags = merge({Name="${var.name}-igw"},var.igw_tags, var.vpc_tags)
    natgw_tags = merge({Name="${var.name}-natgw"},var.natgw_tags, var.vpc_tags)
    private_subnet_tags = merge(var.private_subnet_tags, var.vpc_tags)
    public_subnet_tags = merge(var.public_subnet_tags, var.vpc_tags)
    nat_route_table_tags = var.nat_route_table_tags
    igw_route_table_tags = var.igw_route_table_tags
}

resource "aws_vpc" "main" {
    cidr_block       = var.vpc_cidr
    instance_tenancy = var.instance_tenancy
    enable_dns_support = var.enable_dns_hostnames
    enable_dns_hostnames = var.enable_dns_hostnames

    tags = var.vpc_tags
}

module "aws_subnets" {
    count = var.enable_subnets ? 1 : 0
    source = "./modules/aws-subnet"
    
    private_subnets = var.private_subnets
    public_subnets = var.public_subnets
    vpc_id = aws_vpc.main.id
    public_subnet_tags = local.public_subnet_tags
    private_subnet_tags = local.private_subnet_tags
    
    depends_on = [ aws_vpc.main ]
}

module "igw" {
    count = var.enable_igw ? 1 : 0
    source = "./modules/internet-gateway"

    vpc_id = aws_vpc.main.id
    vpc_default_route_id = aws_vpc.main.default_route_table_id
    igw_route_table_id = module.aws_routes.igw_route_table_id
    public_subnets = module.aws_subnets[0].public-subnet-ids
    
    igw_tags = local.igw_tags

    depends_on = [ module.aws_subnets]
}


module "nat_gw" {
    count = var.enable_nat_gw ? 1 : 0

    source = "./modules/nat-gateway"

    # This is the subnet we attach the nat gw to
    subnet_id = length(module.aws_subnets) > 0 ? module.aws_subnets[0].public-subnet-ids[var.nat_subnet_key].id : ""

    vpc_id = aws_vpc.main.id
    nat-gateway-tags = local.natgw_tags
    private_subnets = module.aws_subnets[0].private-subnet-ids
    nat_route_table_id = module.aws_routes.nat_route_table_id

    depends_on = [ module.igw, module.aws_subnets, module.aws_routes ]
}

module "aws_routes" {
    source = "./modules/aws-route"
    vpc_id = aws_vpc.main.id
    route_table_tags = local.nat_route_table_tags

    depends_on = [ aws_vpc.main ]
}