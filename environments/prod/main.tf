terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "prod/terraform.tfstate"
  #   region         = "eu-central-1"
  #   dynamodb_table = "terraform-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "mid-devops-infra"
      Environment = "prod"
      ManagedBy   = "terraform"
      Owner       = var.owner
    }
  }
}

locals {
  name = "${var.project_name}-prod"
  azs  = ["${var.aws_region}a", "${var.aws_region}b"]
}

module "vpc" {
  source = "../../modules/vpc"

  name               = local.name
  cidr_block         = "10.20.0.0/16"
  azs                = local.azs
  public_subnets     = ["10.20.1.0/24", "10.20.2.0/24"]
  private_subnets    = ["10.20.11.0/24", "10.20.12.0/24"]
  enable_nat_gateway = true

  tags = {
    Environment = "prod"
  }
}

module "ec2" {
  source = "../../modules/ec2"

  name                   = local.name
  vpc_id                 = module.vpc.vpc_id
  subnet_ids             = module.vpc.private_subnet_ids
  instance_type          = var.instance_type
  instance_count         = var.instance_count
  key_name               = var.key_name
  app_port               = 8000
  ssh_cidr_blocks        = var.ssh_cidr_blocks
  alb_security_group_ids = [module.alb.security_group_id]
  user_data              = file("${path.module}/../../scripts/user-data.sh")
  root_volume_size       = 30

  tags = {
    Environment = "prod"
    Role        = "app"
  }
}

module "alb" {
  source = "../../modules/alb"

  name                       = local.name
  vpc_id                     = module.vpc.vpc_id
  subnet_ids                 = module.vpc.public_subnet_ids
  target_instance_ids        = module.ec2.instance_ids
  target_port                = 8000
  health_check_path          = "/health"
  enable_deletion_protection = true # в prod включаем защиту

  tags = {
    Environment = "prod"
  }
}
