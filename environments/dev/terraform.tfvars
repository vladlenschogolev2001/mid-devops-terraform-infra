aws_region     = "eu-central-1"
project_name   = "mid-devops"
owner          = "your-name"
instance_type  = "t3.micro"
instance_count = 1

# ВАЖНО: замени на свой публичный IP, например ["203.0.113.25/32"]
ssh_cidr_blocks = ["0.0.0.0/0"]

# key_name = "my-ssh-key"   # раскомментируй и укажи имя ключа
