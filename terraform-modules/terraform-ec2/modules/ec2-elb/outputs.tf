output "ec2_elb_instances" {
  value = aws_elb.elb.instances
}

output "ec2_elb_dns_name" {
  value = aws_elb.elb.dns_name
}

output "ec2_elb_zone_id" {
  value = aws_elb.elb.zone_id
}

output "source_security_group_id" {
  value = aws_elb.elb.source_security_group_id
}
