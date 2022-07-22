variable "engine" {
    description = "Engine used for RDS database"
    default     = "postgres" 
}

variable "engine_version" {
    description = "Engine version used for postgres"
    default     = "9.6"
}

variable "database_identifier" {
    description = "Identifier for RDS database"
    default     = "postgres"
}

variable "instance_class" {
    description = "Instance type chosen for RDS database"
    default     = "db.t3.micro" 
}

variable "allocated_storage" {
    description = "Storage allocated for RDS database"
    default     = 10
}

variable "max_allocated_storage" {
    description = "Maximum storage allocated for RDS database"
    default     = 20
}

variable "database_name" {
    description = "Name of RDS database"
    default     = "postgres"
}

variable "database_port" {
    description = "Port for postgres"
    default     = 5432
}

variable "database_username" {
    description = "Name of user with access to RDS database"
    default     = "root" 
}

variable "backup_window" {
    description = "3 hours time window to reserve for backups"
    default     = "03:00-06:00"
}

variable "backup_retention_period" {
    description = "Number of days to keep database backups"
    default     = 7
}

variable "maintenance_window" {
    description = "3 hours time window to reserve for maintenance"
    default     = "Sun:00:00-Sun:03:00"
}

variable "vpc_id" {
    description = "EKS cluster's VPC id in dev account"
    default     = "vpc-0347207ecd7659c51"
}

variable "cidr_blocks" { 
    description = "EKS cluster VPC's cidr range"
    default     = ["10.23.0.0/16"]
}

variable "subnet_ids" { 
    description = "EKS cluster VPC's private subnets"
    default     = ["subnet-0def79650903edac4", "subnet-0e38380d110326d7f"]
}

variable "multi_az" {
    description = "Enable multiple availability zones for database"
    default     = true  
}

variable "publicly_accessible" {
    description = "Bool to control if instance is publicly accessible"
    default     = false
}

variable "skip_final_snapshot" {
    description = "Determines whether a final DB snapshot is created before the DB instance is deleted"
    default     = true
}
