/*
output "address" {
  value = aws_db_instance.mssql.address
  description = "Database address"
}

output "port" {
  value = aws_db_instance.mssql.port
  description = "Database port"
}
*/
output "redshift-endpoint" {
  value = aws_redshift_cluster.my_redshift_cluster.endpoint
  description = "AWS Redshift endpoint"
}
