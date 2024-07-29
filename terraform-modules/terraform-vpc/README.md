# Terraform VPC Module Documentation

This documentation provides detailed information on the Terraform variables and resources defined in this project for deploying AWS infrastructure.

## Workspace Information

### General Configuration Variables

These variables are used across multiple resources and define the general setup of the Terraform workspace.

| Name        | Description                           | Type   | Default  |
|-------------|---------------------------------------|--------|----------|
| `name`      | The name used for the VPC             | string |          |
| `region`    | Set the AWS region                    | string |          |
| `profile`   | Sets the AWS profile to use           | string | `default`|
| `env`       | The environment for this resource     | string | `dev`    |
| `group`     | The group that owns the resource      | string | `fortis` |

## Resources Configuration

### VPC

| Name                   | Description                           | Type        | Default |
|------------------------|---------------------------------------|-------------|---------|
| `vpc_cidr`             | Sets the VPC CIDR                     | string      |         |
| `instance_tenancy`     | Sets the instance tenancy             | string      |         |
| `vpc_tags`             | Sets the tags for the VPC             | map(string) |         |
| `enable_dns_hostnames` | Enables/disables DNS hostnames        | bool        | `true`  |
| `enable_dns_support`   | Enables/disables DNS Support          | bool        | `true`  |
| `nat_subnet_key`       | Subnet key to use for public_subnets  | string      |         |

### Internet Gateway

| Name            | Description                                           | Type         | Default |
|--------------------------|-------------------------------------------------------|--------------|---------|
| `igw_tags`               | The tags for the Internet Gateway.                    | `map(string)`| `{}`    |
| `vpc_id`                 | The ID of the VPC to which the IGW is attached.       | `string`     | `null`  |
| `vpc_default_route_id`   | The ID of the default route in the VPC route table.   | `string`     | `null`  |
| `igw_route_table_id`     | The ID of the route table associated with the IGW.    | `string`     | `null`  |
| `public_subnets`         | A map containing data about the public subnets.       | `map(any)`   | `{}`    |

### NAT Gateway

| Name          | Description                                         | Type         | Default |
|------------------------|-----------------------------------------------------|--------------|---------|
| `nat-gateway-tags`     | Set the tags for the NAT Gateway module.            | `map(string)`| `{}`    |
| `subnet_id`            | Use this subnet ID to attach to the Internet Gateway.| `string`     | `null`  |
| `vpc_id`               | Sets the VPC ID.                                    | `string`     | `null`  |
| `nat_route_table_id`   | A string that defines the NAT route table ID.       | `string`     | `null`  |
| `private_subnets`      | A map containing data for private subnets.          | `map(any)`   | `{}`    |

### Subnets

| Name         | Description                              | Type                                              | Default |
|-----------------------|------------------------------------------|---------------------------------------------------|---------|
| `private_subnet_tags` | The tags for internal subnets.           | `map(string)`                                     | `{}`    |
| `public_subnet_tags`  | The tags for external subnets.           | `map(string)`                                     | `{}`    |
| `vpc_id`              | The VPC ID to associate the subnets with.| `string`                                          | `null`  |
| `private_subnets`     | A map of private subnets to create.      | `map(object({cidr_block, availability_zone, enable_nat_gw, lb_association}))` | `{}` |
| `public_subnets`      | A map of public subnets to create.       | `map(object({cidr_block, availability_zone, lb_association}))` | `{}` |

### AWS Routes

| Name            | Description                                       | Type        | Default       |
|--------------------------|---------------------------------------------------|-------------|---------------|
| `igw_tags`               | The tags to assign to the Internet Gateway.       | `map(string)` | `{}`        |
| `vpc_id`                 | The ID of the VPC to be used.                      | `string`    | `null`        |
| `vpc_default_route_id`   | The ID of the default route in the VPC.            | `string`    | `null`        |
| `igw_route_table_id`     | The ID of the NAT route table.                     | `string`    | `null`        |
| `public_subnets`         | A map containing data about the public subnets.    | `map(any)`  | `{}`          |

# Terraform Configuration Outputs

This section documents the outputs provided by the Terraform configuration. These outputs export essential data about the resources created by Terraform, which can be useful for integration with other Terraform modules or external systems.

## Output Descriptions

Detailed descriptions of each output from this Terraform configuration are organized below. These provide insights into the data made available once Terraform applies are successful.

### Outputs Table

| Name               | Description                                                   |
|---------------------------|---------------------------------------------------------------|
| `private_subnets_output`  | Returns a list of the IDs for the private subnets created within the VPC. |
| `public_subnets_output`   | Returns a list of the IDs for the public subnets created within the VPC.  |
| `vpc_id`                  | The ID of the VPC created by the module.                      |


## Usage

These outputs can be used to link resources between different Terraform modules or to provide configuration details to external systems. Here's how you might reference these outputs in another Terraform module:

```hcl
module "another-module" {
  source = "./modules/another-module"

  subnet_id = module.current-module.subnets-output
  vpc_id    = module.current-module.vpc-id
}
```

## Usage

To apply this configuration, update the variables in your `terraform.tfvars` file or pass them directly through the CLI. Review and apply the changes using standard Terraform commands:

Create Workspace
```bash
terraform init
terraform workspace new <workspace name>
```
Apply workspace using tfvar file
```bash
terraform plan -var-file <path to .tfvars file>
terraform apply -var-file <path to .tfvars file>
```