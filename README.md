# Terraform Infrastructure — Middle DevOps Project

Инфраструктура как код (IaC) уровня Middle DevOps на AWS.

## Что внутри

- **Модульная структура** Terraform (VPC, EC2, ALB)
- **Два окружения**: `dev` и `prod` (разные настройки)
- **Remote state** пример (S3 + DynamoDB)
- **Security best practices**:
  - Security Groups с минимальными правами
  - IMDSv2
  - Encrypted EBS
  - Non-public subnets для приложений
- **User-data** скрипт для автоматической настройки EC2
- **Outputs** с полезной информацией

## Архитектура

```
                    Internet
                        │
                   [Internet GW]
                        │
              ┌─────────┴─────────┐
              │      Public       │
              │     Subnets       │
              │   (ALB + NAT)     │
              └─────────┬─────────┘
                        │
              ┌─────────┴─────────┐
              │     Private       │
              │     Subnets       │
              │   (App EC2)       │
              └───────────────────┘
```

## Структура

```
02-terraform-infra/
├── modules/
│   ├── vpc/          # VPC, subnets, IGW, NAT, route tables
│   ├── ec2/          # EC2 instance + security group
│   └── alb/          # Application Load Balancer
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── terraform.tfvars
│   │   └── outputs.tf
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── terraform.tfvars
│       └── outputs.tf
├── scripts/
│   └── user-data.sh
└── backend.tf.example
```

## Быстрый старт

### Требования

- Terraform >= 1.5
- AWS CLI настроен (`aws configure`)
- Аккаунт AWS (можно Free Tier)

### Запуск dev-окружения

```bash
cd environments/dev

# Инициализация
terraform init

# План
terraform plan

# Применение
terraform apply

# Посмотреть outputs
terraform output
```

### Уничтожение инфраструктуры

```bash
terraform destroy
```

## Что показывает этот проект (Middle level)

- Модульный подход к Terraform
- Разделение окружений (dev/prod)
- Правильная работа с variables / outputs / locals
- Security Groups по принципу least privilege
- Remote state (пример конфигурации)
- User-data для bootstrap
- Tagging strategy
- Использование data sources

## Важно

> Перед `terraform apply` в prod обязательно проверь `terraform.tfvars` и стоимость.
> Для обучения лучше использовать только `dev` и сразу делать `destroy`.

## Лицензия

MIT
