variable "aws_region" {
  default = "us-east-1"
  type    = string
}

variable "cluster_name" {
  default = "project-bedrock-cluster"
  type    = string
}

variable "cluster_version" {
  default = "1.28"
  type    = string
}

variable "environment" {
  default = "production"
  type    = string
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  type    = string
}
