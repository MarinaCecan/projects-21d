output "hostname" {
  value       = module.rds.hostname
  description = "The hostname of the RDS instance"
}

output "port" {
  value       = module.rds.port
  description = "The database port"
}

output "username" {
  value       = module.rds.username
  description = "The master username for the database"
}

output "database_name" {
  value       = module.rds.database_name
  description = "The database name"
}

output "status" {
  value       = module.rds.status
  description = "The RDS instance status"
}

output "parameter_name" {
  value       = module.rds.parameter_name
  description = "The name of the parameter"
}

output "parameter_value" {
  value       = module.rds.parameter_value
  description = "The value of the parameter"
  sensitive   = true
}
