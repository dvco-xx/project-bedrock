output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "developer_arn" {
  value = aws_iam_user.developer.arn
}

output "developer_username" {
  value = aws_iam_user.developer.name
}

output "developer_access_key_id" {
  value     = aws_iam_access_key.developer.id
  sensitive = true
}

output "developer_secret_access_key" {
  value     = aws_iam_access_key.developer.secret
  sensitive = true
}

output "postgres_endpoint" {
  value = aws_db_instance.postgres.endpoint
}

output "postgres_password" {
  value     = random_password.postgres.result
  sensitive = true
}

output "mysql_endpoint" {
  value = aws_db_instance.mysql.endpoint
}

output "mysql_password" {
  value     = random_password.mysql.result
  sensitive = true
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.carts.name
}