output "vpc_remote_output" {
  value = module.vpc_state.vpc_remote_output
}

output "ec2_instances" {
  value = flatten(module.ec2_instances.*.instance_ids)
}