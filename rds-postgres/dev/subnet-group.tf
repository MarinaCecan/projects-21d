# Creating private subnets from different availability zones.
resource "aws_subnet" "private-subnets" {
  count             = "${length(var.subnet_cidrs_private)}"

  vpc_id            = var.rds_vpc_id
  cidr_block        = "${var.subnet_cidrs_private[count.index]}"
  availability_zone = "${var.availability_zones[count.index]}"
  tags = {
      Name = "postgres-private-subnet${count.index+1}-${var.identifier}"
  }
}
#Creating a subnet group using the above subnets 
resource "aws_db_subnet_group" "postgres_database_subnet_group" {
  name        = "subnet-group-postgres-${var.identifier}"
  subnet_ids  = aws_subnet.private-subnets.*.id
  description = "Subnet group for PostgreSQL instance."
  tags = {
    Name = "Postgres-subnet-group"
  }
}
