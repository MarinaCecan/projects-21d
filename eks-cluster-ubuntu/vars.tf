variable "cluster_name" {
  default = "eks-cluster"
  type    = string
}

variable "cluster_version" {
  type        = number
  default     = "1.22"
  description = "Kubernetes minor version to use for the EKS cluster"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "region"
}

variable "cidr_block" {
  type        = string
  default     = "172.16.0.0/16"
  description = "Base CIDR block to be used in our VPC."
}

variable "instance_type" {
  type        = string
  default     = "t3.medium"
  description = "instance_type"
}
variable "key_name" {
  type        = string
  default     = "shamil-key"
  description = "SSH key for troubleshooting"
}

variable "on_demand_base_capacity" {
  type        = number
  default     = "0"
  description = "Absolute minimum amount of desired capacity that must be fulfilled by on-demand instances. Default: 0."
}

variable "on_demand_percentage_above_base_capacity" {
  type        = number
  default     = "50"
  description = "Percentage split between on-demand and Spot instances above the base on-demand capacity. Default: 100"
}
variable "desired_capacity" {
  type        = number
  default     = "2"
  description = "The desired number of nodes to create in the node group."
}

variable "min_size" {
  type        = number
  default     = "1"
  description = "The minimum number of nodes to create in the node group."
}

variable "max_size" {
  type        = number
  default     = "4"
  description = "The maximum number of nodes to create in the node group."
}
