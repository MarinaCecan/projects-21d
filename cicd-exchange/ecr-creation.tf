provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "redhat-exchange-api" {
  name                 = "redhat-exchange-api"
  image_tag_mutability = "IMMUTABLE" #to allow versioning 

  image_scanning_configuration {
    scan_on_push = true
  }
    tags = {
      Name = "redhat-exchange-api"
}
}
resource "aws_ecr_repository" "redhat-exchange-web" {
  name                 = "redhat-exchange-web"
  image_tag_mutability = "IMMUTABLE"  #to allow versioning 

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
      Name = "redhat-exchange-web"
}
}
