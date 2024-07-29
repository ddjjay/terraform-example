
output "vpc_id" {
  value = try(data.terraform_remote_state.vpc_module.outputs.vpc_id)
}

output "public_subnets_output" {
  value = try(data.terraform_remote_state.vpc_module.outputs.public_subnets_output)
}

output "private_subnets_output" {
  value = try(data.terraform_remote_state.vpc_module.outputs.private_subnets_output)
}