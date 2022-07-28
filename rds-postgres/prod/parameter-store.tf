# Generating password for rds mysql bd
resource "random_string" "rds_password" {
  length           = var.password_length
  special          = var.password_special
}

# Creating a parameter to keep a password for rds postgres db
resource "aws_ssm_parameter" "rds_password" {
  name         = "${var.password_name}-${var.identifier}-password"
  description  = "password for rds postgres db"
  type         = "SecureString"
  value        = "${random_string.rds_password.result}"
  
  lifecycle {
    ignore_changes = [
      value
    ]
  }
}
