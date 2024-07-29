output "vpc_id" {
  description = "This will return the vpc_id"
  value = module.vpc_state.vpc_id
}

output "web_app_ec2_instances" {
  description = "Returns the web_app instances"
  value = flatten(module.web_app_ec2_instances.*.instance_ids)
}

output "web_app_private_ip" {
  description = "Returns the web_app private ips"
  value = flatten(module.web_app_ec2_instances.*.instance_private_ips)
}

output "sql_ec2_instances" {
  description = "Returns the sql instances"
  value = flatten(module.sql_ec2_instances.*.instance_ids)
}

output "sql_private_ip" {
  description = "Returns the sql private ips"
  value = flatten(module.sql_ec2_instances.*.instance_private_ips)
}

output "bastion_ec2_instances" {
  description = "Returns the bastion host instance ids"
  value = flatten(module.bastion_ec2_instances.*.instance_ids)
}

output "bastion_instance_public_ips" {
  description = "Returns the bastion hosts public ip"
  value = flatten(module.bastion_ec2_instances.*.instance_public_ips)
}

output "bastion_instance_public_dns" {
  description = "Returns the bastion hosts public dns"
  value = flatten(module.bastion_ec2_instances.*.instance_public_dns)
}

output "elb_hostname" {
  description = "Returns the public elb hostname "
  value = module.elb.ec2_elb_dns_name
}