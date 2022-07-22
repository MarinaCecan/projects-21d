data "aws_iam_policy_document" "eks_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["eks.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "eks_role" {
  name               = "eks-cluster-ubuntu"
  assume_role_policy = data.aws_iam_policy_document.eks_role.json
}

resource "aws_iam_role_policy_attachment" "eks_role_amazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "eks_role_amazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_role.name
}
