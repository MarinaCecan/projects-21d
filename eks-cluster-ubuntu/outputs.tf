output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = module.eks_cluster.endpoint
}

output "oidc" {
  value = module.eks_cluster.oidc
}
  
  
  
  
