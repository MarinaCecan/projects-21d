data "aws_iam_policy_document" "eksnodes_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "eksnodes_role" {
  name               = "eks-node-group-ubuntu"
  assume_role_policy = data.aws_iam_policy_document.eksnodes_role.json
}

resource "aws_iam_role_policy_attachment" "eksnodes_role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eksnodes_role.name
}

resource "aws_iam_role_policy_attachment" "eksnodes_role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eksnodes_role.name
}

resource "aws_iam_role_policy_attachment" "eksnodes_role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eksnodes_role.name
}

resource "aws_iam_instance_profile" "eksnodes_profile" {
  name = "eks-cluster-ubuntu-21d-profile"
  role = aws_iam_role.eksnodes_role.name
}
