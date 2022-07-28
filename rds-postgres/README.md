# AWS RDS POSTRGRES DATABASE

## Pre Requirements

An existing VPC

## Description

This module deploys RDS PostgreSQL database for the exchange app.

  

There are two folders (dev and prod) containing configuration for database creation for development and production environments.

## AWS RDS PostgreSQL Infrastructure:

#### Root module:

**main.tf** : creates resources such as db instance and db security group

**subnet-group.tf**: creates three private subnets and the subnet group from them

**parameter-store.tf**: generate a random password that will be stored in AWS Systems Manager Parameter Store

**enhanced-mon.tf**: creates IAM role and attaches IAM policy that will allow us to enable enhanced monitoring

**var.tf**: contains variables for all resources

**backend.tf**: allows us to store tfstate file in AWS s3

  

#### Child module:

In the module directory, you can find main.tf file that contains:

1.  **provider**: This specifies which cloud platform you are going to interact with (AWS, Azure, GCP etc.). This also controls the region you are deploying your resources and the security credentials for your user.

  

2.  **module**: that will be called in the root module. Here we pass all the values for our variables

  

## Notes:

Values of "rds_vpc_id", "private_network_cidr" attributes were predefined and found in AWS console.

Values of the other attributes such as "allocated_storage", "backup_retention_period" and etc can be changed by your needs.

  

## Usage

Go to the module in dev or prod folder and run the following commands:

  

`- terraform init`

`- terraform plan`

`- terraform apply`

  
  

## Testing Database

  

1. To test our database Bastion Host instance needs to be created in the same VPC (Security group of our db allows access only to resources in the same VPC) in the public subnet with Internet gateway configured.

  

2. After ssh-ing to the instance, postgresql package must be installed. Run the following command:

  

`sudo yum install postgresql`

  

3. After installation, run :

`psql --host=rds-postgres-for-exchange-dev.czxfqxkm6ggp.us-east-1.rds.amazonaws.com --port=5432 --username=dbuser --password --dbname=postgresdbforexchange`

  

Password can be found in AWS Systems Manager Parameter Store

  

4. To list the databases run :

`\l`
