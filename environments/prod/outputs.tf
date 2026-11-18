output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "ALB DNS name"
  value       = module.alb.alb_dns_name
}

output "instance_private_ips" {
  description = "Private IPs of application instances"
  value       = module.ec2.private_ips
}
