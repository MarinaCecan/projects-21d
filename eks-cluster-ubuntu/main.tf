module "eks_cluster" {
  source                                   = "./eks-cluster"
  cluster_name                             = var.cluster_name
  cluster_version                          = var.cluster_version
  region                                   = var.region
  cidr_block                               = var.cidr_block
  instance_type                            = var.instance_type
  key_name                                 = var.key_name
  desired_capacity                         = var.desired_capacity
  min_size                                 = var.min_size
  max_size                                 = var.max_size
  on_demand_base_capacity                  = var.on_demand_base_capacity
  on_demand_percentage_above_base_capacity = var.on_demand_percentage_above_base_capacity
}


