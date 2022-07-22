resource "aws_security_group" "eks_sg" {
  name        = "eks-sg-ubuntu"
  description = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.eksvpc.id

  ingress {
    description = "Reccommended inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "eks-sg-ubuntu"
  }
}

resource "aws_security_group" "eksnodes_sg" {
  name        = "eks-cluster-nodes-sg-ubuntu"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.eksvpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Recommended inbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  ingress {
    description     = "inbound from control plane"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id]
  }

  ingress {
    description     = "inbound traffic from control plane"
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id]
  }

  tags = {
    Name                                        = "eksvpc"
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  }
}

resource "aws_security_group_rule" "node-ingress-cluster-inbound" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
  source_security_group_id = aws_security_group.eksnodes_sg.id
  to_port                  = 443
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster-egress-node-outbound" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_eks_cluster.eks_cluster.vpc_config[0].cluster_security_group_id
  source_security_group_id = aws_security_group.eksnodes_sg.id
  to_port                  = 65535
  type                     = "egress"
}
