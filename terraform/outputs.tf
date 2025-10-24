output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  description = "EKS cluster name"
  value       = aws_eks_cluster.main.name
}

output "cluster_version" {
  description = "EKS cluster version"
  value       = aws_eks_cluster.main.version
}

output "developer_username" {
  description = "Developer IAM username"
  value       = aws_iam_user.developer.name
}

output "developer_access_key_id" {
  description = "Developer user access key ID"
  value       = aws_iam_access_key.developer_key.id
  sensitive   = true
}

output "developer_secret_access_key" {
  description = "Developer user secret access key"
  value       = aws_iam_access_key.developer_key.secret
  sensitive   = true
}