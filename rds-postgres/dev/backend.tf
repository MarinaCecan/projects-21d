terraform {
  backend "s3" {
    bucket = "final-project-21d-redhat"
    key    = "rds-postgres-dev/postgres-db-statefile.tfstate"
    region = "us-east-1"
  }
}
