
resource "aws_redshift_cluster" "my_redshift_cluster" {
  cluster_identifier = "test-redshift-cluster"
  database_name      = "test_database"
  master_username    = "admin"
  master_password    = "Admin_12"
  node_type          = "dc2.large"
  cluster_type       = "single-node"

  skip_final_snapshot = true
}
/*
resource "aws_db_instance" "mssql" {
  identifier_prefix = "mssql-ig"
  engine = "sqlserver-ex"
  allocated_storage = 10
  instance_class = "db.t3.small"
#  name = "example_database"
  username = "admin_user"
  skip_final_snapshot = true

  password = "change_for_prod"

  publicly_accessible = true
  license_model      = "license-included"
}
*/
