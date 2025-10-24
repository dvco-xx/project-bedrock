variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  default     = "project-bedrock-cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  default     = "1.28"
  type        = string
}

variable "environment" {
  description = "Environment name"
  default     = "production"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = "10.0.0.0/16"
  type        = string
}