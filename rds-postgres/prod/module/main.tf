provider "aws" {
  region = "us-east-1"
}

# Module for creating db instance
module "aws_db_instance" {
    source                  = "../"
    identifier              = "prod"
    allocated_storage       = 10
    database_instance_class = "db.t3.micro"
    max_allocated_storage   = 20
    database_version        = 10
    database_name           = "postgresdbforexchange"
    backup_retention_period = 7
    storage_type            = "gp2"
    database_master_user    = "dbuser"
    maintenance_window      = "Mon:00:00-Mon:03:00"
    security_group_name     = "postgres-sg"
    private_network_cidr    = ["10.20.0.0/16"]
    password_length         = 15
    password_special        = true
    password_name           = "rds-postgres"
    rds_vpc_id              = "vpc-0a6b534f3322e8509"
    subnet_cidrs_private    = ["10.20.4.0/24", "10.20.3.0/24"]
    availability_zones      = ["us-east-1a", "us-east-1b"]
    name_prefix             = "rds-enhanced-monitoring-"
    policy_arn              = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
    performance_insights_retention_period = 7
    monitoring_interval     = 30
}
