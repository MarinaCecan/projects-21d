resource "aws_vpc" "eksvpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true # Internal domain name
  enable_dns_hostnames = true # Internal host name
  tags = {
    Name                                        = "eksvpc"
  }
}

resource "aws_internet_gateway" "eks-igw" {
  vpc_id = aws_vpc.eksvpc.id

  tags = {
    Name                                        = "eks-igw"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "private-us-east-1a" {
  vpc_id            = aws_vpc.eksvpc.id
  cidr_block        = "172.16.0.0/19"
  availability_zone = "us-east-1a"

  tags = {
    "Name"                                      = "private-us-east-1a"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "private-us-east-1b" {
  vpc_id            = aws_vpc.eksvpc.id
  cidr_block        = "172.16.32.0/19"
  availability_zone = "us-east-1b"

  tags = {
    "Name"                                      = "private-us-east-1b"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "private-us-east-1c" {
  vpc_id            = aws_vpc.eksvpc.id
  cidr_block        = "172.16.64.0/19"
  availability_zone = "us-east-1c"

  tags = {
    "Name"                                      = "private-us-east-1c"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "public-us-east-1a" {
  vpc_id                  = aws_vpc.eksvpc.id
  cidr_block              = "172.16.96.0/19"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "public-us-east-1a"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "public-us-east-1b" {
  vpc_id                  = aws_vpc.eksvpc.id
  cidr_block              = "172.16.128.0/19"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "public-us-east-1b"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}

resource "aws_subnet" "public-us-east-1c" {
  vpc_id                  = aws_vpc.eksvpc.id
  cidr_block              = "172.16.160.0/19"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    "Name"                                      = "public-us-east-1c"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }
}


resource "aws_route_table" "eksvpc_route_table" {
  vpc_id = aws_vpc.eksvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.eks-igw.id
  }
}

resource "aws_route_table_association" "public-us-east-1a" {
  subnet_id      = aws_subnet.public-us-east-1a.id
  route_table_id = aws_route_table.eksvpc_route_table.id
}

resource "aws_route_table_association" "public-us-east-1b" {
  subnet_id      = aws_subnet.public-us-east-1b.id
  route_table_id = aws_route_table.eksvpc_route_table.id
}

resource "aws_route_table_association" "public-us-east-1c" {
  subnet_id      = aws_subnet.public-us-east-1c.id
  route_table_id = aws_route_table.eksvpc_route_table.id
}
