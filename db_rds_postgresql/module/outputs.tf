output "hostname" {
  value       = aws_db_instance.rds.address
  description = "The hostname of the RDS instance"
}

output "port" {
  value       = aws_db_instance.rds.port
  description = "The database port"
}

output "username" {
  value       = aws_db_instance.rds.username
  description = "The master username for the database"
}

output "database_name" {
  value       = aws_db_instance.rds.db_name
  description = "The database name"
}

output "status" {
  value       = aws_db_instance.rds.status
  description = "The RDS instance status"
}

output "parameter_name" {
  value       = aws_ssm_parameter.rds_password.name
  description = "The name of the parameter"
}

output "parameter_value" {
  value       = aws_ssm_parameter.rds_password.value
  description = "The value of the parameter"
}
