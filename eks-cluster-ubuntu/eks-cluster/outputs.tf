output "oidc" {
  value       = aws_eks_cluster.eks_cluster.id
  description = "description"
}

output "endpoint" {
  value = aws_eks_cluster.eks_cluster.endpoint
}
