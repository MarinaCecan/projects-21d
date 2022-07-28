variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "public_subnet_cidrs" {
  default = [
    "10.0.140.0/24",
    "10.0.120.0/24",
    "10.0.130.0/24"
  ]
}

variable "private_subnet_cidrs" {
  default = [
    "10.0.150.0/24",
    "10.0.160.0/24",
    "10.0.170.0/24"
  ]
}

variable "eks_cluster_name" {
  default = "21d-redhat-terraform"
}

variable "eks_cluster_version" {
  default = "1.21"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_type1" {
  default = "t3a.medium"
}
variable "instance_type2" {
  default = "t3a.small"
}
variable "instance_type3" {
  default = "t3a.micro"
}

variable "instance_ami" {
  default = "ami-0fb604efcd6aaf3d5"
}
variable "desired_capacity" {
  default = 2
}

variable "min_size" {
  default = 2
}

variable "max_size" {
  default = 4
}

variable "on_demand_base_capacity" {
  default = 1
}

variable "on_demand_percentage_above_base_capacity" {
  default = 20
}
