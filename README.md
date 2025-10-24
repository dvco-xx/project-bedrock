#project-bedrock-terraform-assignment

# Application Infrastructure

This project deploys the retail-store-sample-app to AWS EKS using Terraform and Kubernetes.

## Prerequisites

- Terraform v1.0+
- AWS CLI v2
- kubectl
- Git

## Architecture

- VPC with public and private subnets
- RDS database in private subnet
- Application Load Balancer

## Usage

1. Configure AWS credentials
2. Create `terraform.tfvars`
3. Update variables in `terraform.tfvars`
4. Run `terraform init`
5. Run `terraform plan`
6. Run `terraform apply`

## Variables

| Name          | Description       | Type   | Default  |
| ------------- | ----------------- | ------ | -------- |
| environment   | Environment name  | string | -        |
| instance_type | EC2 instance type | string | t3.micro |

## Outputs

| Name              | Description                   |
| ----------------- | ----------------------------- |
| load_balancer_dns | DNS name of the load balancer |
| database_endpoint | RDS database endpoint         |
