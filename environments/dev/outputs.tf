output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "alb_dns_name" {
  description = "ALB DNS name — open this in browser"
  value       = module.alb.alb_dns_name
}

output "instance_private_ips" {
  description = "Private IPs of application instances"
  value       = module.ec2.private_ips
}

output "ssh_hint" {
  description = "How to SSH (if key_name is set)"
  value       = "ssh -i <your-key.pem> ec2-user@<bastion-or-via-ssm>"
}
