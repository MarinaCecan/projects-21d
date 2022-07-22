resource "random_string" "rds_password" {
  length           = 15
  special          = true
  override_special = "!#$&"
}

resource "aws_ssm_parameter" "rds_password" {
  name        = "/dev/postgres"
  description = "Admin password for RDS Postgresql"
  type        = "SecureString"
  value       = random_string.rds_password.result
}

data "aws_ssm_parameter" "rds_password" {
  name       = "/dev/postgres"
  depends_on = [aws_ssm_parameter.rds_password]
}
