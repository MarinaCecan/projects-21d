variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = number
}

variable "region" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "instance_type" {
  type = string
}
variable "key_name" {
  type = string
}

variable "on_demand_base_capacity" {
  type = number
}

variable "on_demand_percentage_above_base_capacity" {
  type = number
}

variable "desired_capacity" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}




