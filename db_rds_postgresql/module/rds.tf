resource "aws_db_instance" "rds" {
  engine                  = var.engine
  engine_version          = var.engine_version
  identifier              = var.database_identifier
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  max_allocated_storage   = var.max_allocated_storage
  db_name                 = var.database_name
  port                    = var.database_port
  username                = var.database_username
  password                = data.aws_ssm_parameter.rds_password.value    
  vpc_security_group_ids  = [aws_security_group.sg_for_rds.id]           
  db_subnet_group_name    = aws_db_subnet_group.eks_private_subnets.name 
  backup_window           = var.backup_window                            
  backup_retention_period = var.backup_retention_period
  maintenance_window      = var.maintenance_window
  multi_az                = var.multi_az                                     
  publicly_accessible     = var.publicly_accessible
  skip_final_snapshot     = var.skip_final_snapshot
  tags = merge(
    {
      Name        = "Database RDS Postgres"
      Project     = "exchange-21d-ubuntu"
      Environment = "dev"
    }
  )
}
