output "instance_ids" {
  value = aws_instance.ec2_instance.*.id
  description = "List of IDs of the instances created"
}

output "instance_public_ips" {
  value = aws_instance.ec2_instance.*.public_ip
  description = "List of public IPs of the instances created"
}

output "instance_private_ips" {
  value = aws_instance.ec2_instance.*.private_ip
  description = "List of private IPs of the instances created"
}

output "instance_private_dns" {
  value = aws_instance.ec2_instance.*.private_dns
  description = "List of Private DNS of the instances created"
}

output "instance_public_dns" {
  value = aws_instance.ec2_instance.*.public_dns
  description = "List of Private DNS of the instances created"
}
