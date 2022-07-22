terraform {
  backend "s3" {
    bucket = "21d-ubuntu-iam-tf-state-s3"
    key    = "eks-cluster/terraform.tfstate"
    region = "us-east-1"
  }
}
