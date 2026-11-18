variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "mid-devops"
}

variable "owner" {
  description = "Owner tag"
  type        = string
  default     = "devops-team"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "Number of EC2 instances"
  type        = number
  default     = 1
}

variable "key_name" {
  description = "Name of the SSH key pair in AWS"
  type        = string
  default     = null
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed to SSH (replace with your IP!)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}
