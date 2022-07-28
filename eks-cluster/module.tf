provider "aws" {
  region = "us-east-1"
}

module "eks_cluster_with_managed_node_group" {
  source               = "./module"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs

  eks_cluster_name                         = var.eks_cluster_name
  eks_cluster_version                      = var.eks_cluster_version
  instance_type                            = var.instance_type
  instance_type1                           = var.instance_type1
  instance_type2                           = var.instance_type2
  instance_type3                           = var.instance_type3
  instance_ami                             = var.instance_ami
  desired_capacity                         = var.desired_capacity
  min_size                                 = var.min_size
  max_size                                 = var.max_size
  on_demand_base_capacity                  = var.on_demand_base_capacity
  on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity

}
