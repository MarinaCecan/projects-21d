variable "engine" {
    type        = string
}

variable "engine_version" {
    type        = string
}

variable "database_identifier" {
    type        = string
}

variable "instance_class" {
    type        = string
}

variable "allocated_storage" {
    type        = number
}

variable "max_allocated_storage" {
    type        = number
}

variable "database_name" {
    type        = string
}

variable "database_port" {
    type        = number
}

variable "database_username" {
    type        = string
}

variable "backup_window" {
    type        = string
}

variable "backup_retention_period" {
    type        = number
}

variable "maintenance_window" {
    type        = string
}

variable "vpc_id" {
    type        = string
}

variable "cidr_blocks" {
    type        = list
}

variable "subnet_ids" {
    type        = list
}

variable "multi_az" {
    type        = bool 
}

variable "publicly_accessible" {
    type        = bool
}

variable "skip_final_snapshot" {
    type        = bool
}
