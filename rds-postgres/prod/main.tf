# Configuration for rds postgres db instanse
resource "aws_db_instance" "postgres-db" {
  identifier               = "rds-postgres-for-exchange-${var.identifier}"
  allocated_storage        = var.allocated_storage
  backup_retention_period  = var.backup_retention_period
  engine                   = "postgres"
  engine_version           = var.database_version
  instance_class           = var.database_instance_class
  multi_az                 = true
  db_name                  = "${var.database_name}-${var.identifier}"
  db_subnet_group_name     = aws_db_subnet_group.postgres_database_subnet_group.name
  port                     = 5432
  publicly_accessible      = false
  storage_encrypted        = true 
  storage_type             = var.storage_type 
  username                 = var.database_master_user
  password                 = aws_ssm_parameter.rds_password.value
  vpc_security_group_ids   = [aws_security_group.postgres-sg.id]
  skip_final_snapshot      = true
  maintenance_window       = var.maintenance_window
  monitoring_interval      = var.monitoring_interval
  monitoring_role_arn      = aws_iam_role.rds_enhanced_monitoring.arn

  performance_insights_enabled          = true
  performance_insights_retention_period = var.performance_insights_retention_period

}
# Configuration for rds postgres security group
  
resource "aws_security_group" "postgres-sg" {
  name        = "${var.security_group_name}-${var.identifier}"
  description = "RDS postgres servers (terraform-managed)"
  vpc_id      = var.rds_vpc_id
  
  # Only postgres in
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.private_network_cidr
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
