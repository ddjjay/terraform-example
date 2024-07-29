# Terraform web-app module for AWS

This README documents the variables, outputs and resources used in the Terraform configuration for deploying resources on AWS.

## Variables

Below are descriptions of the variables used in this Terraform configuration

### EC2 Instance Configuration

| Name              | Type        | Default | Required | Description                                      |
|-------------------|-------------|---------|----------|--------------------------------------------------|
| `ami_id`          | `string`    |         | Yes      | The ID of the Amazon Machine Image (AMI) to be used for the EC2 instances. |
| `instance_type`   | `string`    |         | Yes      | The type of EC2 instance to deploy, e.g., 't2.micro'. |
| `instance_count`  | `number`    | `1`     | No       | The number of instances to launch. |

### Network Configuration

| Name                 | Type          | Default | Required | Description                                       |
|----------------------|---------------|---------|----------|---------------------------------------------------|
| `vpc_id`             | `string`      |         | Yes      | The ID of the VPC where resources will be deployed. |
| `subnet_ids`         | `list(string)`|         | Yes      | A list of subnet IDs where instances will be launched. |

### Security Configuration

| Name                  | Type          | Default | Required | Description                                        |
|-----------------------|---------------|---------|----------|----------------------------------------------------|
| `security_group_ids`  | `list(string)`|         | Yes      | A list of Security Group IDs to be attached to the instances. |

### Tagging

| Name       | Type         | Default | Required | Description                              |
|------------|--------------|---------|----------|------------------------------------------|
| `tags`     | `map(string)`| `{}`    | No       | A map of tags to apply to all resources that support tagging. |

## Usage

To use this Terraform configuration, provide values for the required variables in your `terraform.tfvars` file or at the command line. Here is an example of a `terraform.tfvars` file:

```hcl
ami_id            = "ami-0c55b159cbfafe1f0"
instance_type     = "t2.micro"
vpc_id            = "vpc-0a12bc34d56789ef0"
subnet_ids        = ["subnet-abcdef01", "subnet-abcdef02"]
security_group_ids = ["sg-0123456789abcdef0"]
instance_count    = 3
tags              = {
  "Environment" = "development"
  "Project"     = "Web App"
}
```

# Terraform Configuration Outputs

This section documents the outputs provided by the Terraform configuration

## Outputs

Below are descriptions of the outputs from this Terraform configuration

### Output Details

| Name                  | Description                                              |
|------------------------------|----------------------------------------------------------|
| `vpc_id`                     | The ID of the VPC created by the module.                 |
| `web_app_ec2_instances`      | Returns the instance IDs of the web application EC2 instances. |
| `web_app_private_ip`         | Returns the private IP addresses of the web application EC2 instances. |
| `sql_ec2_instances`          | Returns the instance IDs of the SQL server EC2 instances. |
| `sql_private_ip`             | Returns the private IP addresses of the SQL server EC2 instances. |
| `bastion_ec2_instances`      | Returns the instance IDs of the bastion host EC2 instances. |
| `bastion_instance_public_ips`| Returns the public IP addresses of the bastion host EC2 instances. |
| `bastion_instance_public_dns`| Returns the public DNS names of the bastion host EC2 instances. |
| `elb_hostname`               | Returns the public DNS hostname of the Elastic Load Balancer associated with the EC2 instances. |

## Output Usage

Outputs are used to share information about resources created by Terraform with other Terraform configurations, or to provide necessary data for external use. Here are examples of how these outputs might be used:

### Using Output in Terraform

You can reference these outputs in other parts of your Terraform configuration that require these details. For instance, you might need the VPC ID for setting up subnets in a different module:

```hcl
module "subnets" {
  source = "./modules/subnets"
  vpc_id = module.vpc.vpc_remote_output
}
