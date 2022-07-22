resource "aws_db_subnet_group" "eks_private_subnets" {
  name       = "database_private_subnets"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "Private subnets for RDS Postgres in EKS"
  }
}
