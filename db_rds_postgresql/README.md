## **Creating RDS Postgres for Exchange app in the project "exchange-21d-uduntu"**

### A Terraform module to create an Amazon Web Services (AWS) PostgreSQL Relational Database Server (RDS) 
---
>**Usage:**

To run this database you need to execute in "db_rds_postgresql" directory:
- terraform init
- terraform plan
- terraform apply

---

### Requirements
- an existing VPC with private subnets
---
### AWS Resources used to create RDS:
| Resource                     | Description |
| ---------------------------- | ----------- |
|   `aws_db_instance`          | Provides a RDS instance resource |
|   `aws_db_subnet_group`      | Provides a RDS DB subnet group resource |
|   `aws_security_group`       | Provides a security group resource |
|   `random_string`            | Generates a random permutation of alphanumeric characters and optionally special characters |
|   `aws_ssm_parameter`        | Provides an SSM Parameter resource |


![RDS Postgres Medium](https://user-images.githubusercontent.com/100246287/170411962-744b32ff-3b65-4902-94fe-dd7f8e3d3bb9.jpeg)

---

#### File structure:
```
└── db_rds_postgresql
    ├── README.md
    ├── main.tf
    ├── module
    │   └── rds
    │       ├── db_security_group.tf
    │       ├── db_subnet_group.tf
    │       ├── outputs.tf
    │       ├── parameter_store.tf
    │       ├── rds.tf
    │       └── vars.tf
    ├── outputs.tf
    ├── providers.tf
    ├── s3_backend.tf
    └── vars.tf
```

>The "db_rds_postgresql" is a main directory which contains all the files to create RDS postgresql database in EKS cluster.

>There are root module in "main.tf" file, and child modules in "module/rds" dicrectory. 

>Child module consist of:
- "db_security_group" file which creates security group for database

- "db_subnet_group.tf" file creates subnet group which consist of private subnets of VPC of the EKS cluster

- "outputs.tf" contains output values which will be used to get into database through AWS CLI

- "parameter_store.tf" file generates a random 15 characters long password for database user and store it in AWS Parameter Store

- "rds.tf" file creates RDS Postgresql Database

- "vars.tf" file contains variables which is used for creating database and above resources

>The "outputs.tf" file in root module reflects output values in child module.

>Cloud provider information kept in "provider.tf" file

>The "s3_backend.tf" file dispatches terraform state file to s3_bucket in AWS.

>Root module variables are in "vars.tf" keep values that needed to create database. **If needed values can be overwritten in this file and database configuration will be changed.**

---

#### Output values which will be used to get into database through AWS CLI:
| Output value                 | Description |
| ---------------------------- | ----------- |
|   `hostname`                 | Hostname of database instance |
|   `port`                     | Port of database instance |
|   `username`                 | Master username for database |
|   `database_name`            | Name of database instance |
|   `status`                   | Database instance status |
|   `parameter_name`           | Name of parameter |
|   `parameter_value`          | Value of parameter |

---

### Connecting to an Amazon RDS PostgreSQL instance
If your client computer has PostgreSQL installed, you can use a local instance of psql to connect to a PostgreSQL DB instance. To connect to the PostgreSQL DB instance using psql, provide host information, port number, access credentials, and the database name. 
To test the database create a bastion host, ssh into it and use the following command through AWS CLI:

    psql --host=DB_instance_endpoint --port=port --username=master_user_name --password --dbname=database_name

**Values will be taken from outputs.**

#### Next you need to provide password for database which is stored in AWS Parameter Store.

#### Then you can run following commands:
| Commands            | Description |
| ------------------- | ----------- |
| `\l`                | to list all databases in the current PostgreSQL database server |
| `\dt`               | to list all tables in the current database |
| `\d table_name`     | to describe a table such as a column, type, modifiers of columns, etc.|
| `\dn`               | to list all schemas of the currently connected database |
| `\df`               | to list available functions in the current database |
| `\dv`               | to list available views in the current database |
| `\du`               | to list all users and their assign roles |
| `SELECT version();` | to retrieve the current version of PostgreSQL server |
| `\g`                | to save time typing the previous command again |
| `\s`                | to display command history |
| `\q`                | to quit psql |

---

Examples:
```    
SELECT CURRENT_DATE;
```
The output is a DATE value as follows:
```    
2022-06-02
```

>First, create a table named delivery for demonstration:
```
CREATE TABLE delivery(
    delivery_id serial PRIMARY KEY,
    product varchar(255) NOT NULL,
    delivery_date DATE DEFAULT CURRENT_DATE
);
```

In the delivery table, we have the delivery_date whose default value is the result of the CURRENT_DATE function.

>Second, insert a new row into the delivery table:
```
INSERT INTO delivery(product)
VALUES('MacOS');
```
In this INSERT statement, we did not specify the delivery date, therefore, PostgreSQL used the current date as the default value.

>Third, verify whether the row was inserted successfully with the current date by using the following query:
```
SELECT * FROM delivery;
```

As we can see, the current date was inserted into the delivery_date column.

Noted that we may see a different value in the delivery_date column, depending on the date you execute the query.

---
Let's create a table inside the database postgres
We will create an orders table to store the list of orders

Enter code to create a table
```
CREATE TABLE IF NOT EXISTS orders (
    id INT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    order_date DATE,
    price INT NOT NULL,
    description TEXT,
    created_at TIMESTAMP NOT NULL
) ;
```
Check the relation of tables
```
\d orders;
```

Next, We will create a new table order_status with a foreign key order_id that references the primary key of orders table.
```
CREATE TABLE IF NOT EXISTS order_status (
    status_id INT,
    order_id INT,
    status VARCHAR(255) NOT NULL,
    is_completed BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (status_id),
    FOREIGN KEY (order_id)
    REFERENCES orders (id)
    ON UPDATE RESTRICT ON DELETE CASCADE
);
```
```
\d order_status
```

---

### References:
- Terraform Registry https://registry.terraform.io/
- Hashicorp Learn https://learn.hashicorp.com
- Terraform Best Practices https://github.com/ozbillwang/terraform-best-practices
- The PostgreSQL Global Development Group https://www.postgresql.org/
- AWS Documentation https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/CHAP_PostgreSQL.html
- Terraform module to create an Amazon Web Services (AWS) PostgreSQL Relational Database Server (RDS) by azavea. Source Code: github.com/azavea/terraform-aws-postgresql-rds
- Postgresql commands https://www.postgresqltutorial.com/postgresql-administration/psql-commands/
