terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Раскомментируй и настрой для remote state
  # backend "s3" {
  #   bucket         = "your-terraform-state-bucket"
  #   key            = "dev/terraform.tfstate"
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
      Environment = "dev"
      ManagedBy   = "terraform"
      Owner       = var.owner
    }
  }
}

locals {
  name = "${var.project_name}-dev"
  azs  = ["${var.aws_region}a", "${var.aws_region}b"]
}

module "vpc" {
  source = "../../modules/vpc"

  name               = local.name
  cidr_block         = "10.10.0.0/16"
  azs                = local.azs
  public_subnets     = ["10.10.1.0/24", "10.10.2.0/24"]
  private_subnets    = ["10.10.11.0/24", "10.10.12.0/24"]
  enable_nat_gateway = true

  tags = {
    Environment = "dev"
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
  root_volume_size       = 20

  tags = {
    Environment = "dev"
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
  enable_deletion_protection = false

  tags = {
    Environment = "dev"
  }
}
