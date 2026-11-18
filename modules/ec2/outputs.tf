output "instance_ids" {
  description = "List of instance IDs"
  value       = aws_instance.app[*].id
}

output "private_ips" {
  description = "List of private IP addresses"
  value       = aws_instance.app[*].private_ip
}

output "security_group_id" {
  description = "Security group ID of the instances"
  value       = aws_security_group.app.id
}
