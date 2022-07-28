variable "identifier" {
  description = "identifies env, can be dev or prod" 
  type        = string
}
variable "rds_vpc_id" {
  description = "The ID of the VPC into which to deploy the database."
  type        = string
}

variable "maintenance_window" {
  description = "The window to perform maintenance in"
  type        = string
}

variable "database_instance_class" {
  description = "The instance type of the database instance."
  default     = "db.t2.micro"
  type        = string
}
variable "allocated_storage" {
  description = "The allocated storage in GBs."
  default     = 10
  type        = number
}
variable "max_allocated_storage" {
  description = "When configured, the upper limit to which Amazon RDS can automatically scale the storage of the DB instance. See the terraform documentation for more information."
  type        = number
}
variable "database_version" {
  description = "The database version. If omitted, it lets Amazon decide."
  type        = number
}

variable "database_name" {
  description = "The name of the database schema to create. If omitted, no database schema is created initially."
  type        = string
}
variable "database_master_user" {
  description = "The password for the master database user."
  type        = string
}

variable "backup_retention_period" {
  description = "The number of days to retain database backups."
  default     = 7
  type        = number
}

variable "storage_type" {
  description = "The type of storage to use, either \"standard\" (magnetic) or \"gp2\" (general purpose SSD)."
  default = "standard"
  type        = string
}
#Variables for user, user-password
variable "password_length" {
  description = "Length of the password"
  type        = number
}
variable "password_special"{
  description = "If the password should include special characters"

}
variable "password_name" {
  description = "Name of the ssm parameter"
  type        = string
}

#Variable for security group
variable "security_group_name" {
    description = "Security group name of the database"
    type        = string
}
variable "private_network_cidr" {
  description = "The CIDR of the private network allowed access to the database."
  type        = list
}

#Variables for subnets

variable "subnet_cidrs_private" {
    description = "Subnet CIDRs for private subnets"
    type = list
}

variable "availability_zones" {
    description = "Availability zones for private subnets"
    type = list
}

#Variables for enhanced monitoring and role

variable name_prefix {
  type        = string
  description = "Name of the IAM role for enhanced monitoring"
}
variable  policy_arn {
  type        = string
  default     = ""
  description = "Policy arn that will be attached to IAM role"
}

 variable monitoring_interval {
   type        = number
   default     = "30"
   description = "description"
 }
 
 variable performance_insights_retention_period {
   type        = number
   default     = "7"
   description = "description"
 }
