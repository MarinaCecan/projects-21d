resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    security_group_ids = [aws_security_group.eks_sg.id]
    subnet_ids = [
      aws_subnet.public-us-east-1a.id,
      aws_subnet.public-us-east-1b.id,
      aws_subnet.public-us-east-1c.id,
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eksnodes_role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eksnodes_role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eksnodes_role-AmazonEC2ContainerRegistryReadOnly
  ]
}
