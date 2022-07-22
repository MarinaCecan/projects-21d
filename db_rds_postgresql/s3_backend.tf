terraform {
  backend "s3" {
    bucket = "21d-ubuntu-iam-tf-state-s3"  # S3 bucket in EKS cluster
    key    = "rds-postgres.tfstate"
    region = "us-east-1"
  }
}
