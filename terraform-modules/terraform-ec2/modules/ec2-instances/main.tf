locals {
  ec2_tags = var.ec2_tags
}

resource "aws_instance" "ec2_instance" {
  count         = var.instance_count
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id = var.subnet_id
  associate_public_ip_address = var.associate_public_ip_address
  security_groups = var.security_group_ids
  key_name = var.key_name
  user_data = var.user_data

  # Specify other necessary configurations:
  # subnet_id, security_group_ids, tags, etc.

  tags = merge({
    Name = "${var.name}-${count.index}"
  }, local.ec2_tags)
}