resource "aws_security_group" "sg_for_rds" {
  name        = "allow_rds_postgres"
  description = "Allow RDS-Postgres traffic"
  vpc_id      = var.vpc_id

  ingress {
    description  = "allow RDS-Postgres port"
    from_port    = 5432
    to_port      = 5432
    protocol     = "tcp"
    cidr_blocks  = var.cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_rds_postgres"
  }
}
