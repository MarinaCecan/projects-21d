Automate deployment of Exchange app to EC2 hosts (Packer)

1) This app consists of 2 parts: web and api. We need to create an AMI first using Packer and then automate deployment of an app via Terraform.
2) you need to run Packer code first with the following command: packer build name-of-the-file.js . This builds an AMI image that contains our application and starts an npm deamon on the reboot.
3) Using Terraform we can proceed to building an infractucture. Terraform code builds the following recources: ASG connected to an ALB and EC2 instances (with newly created AMI), also VPC with IG, RT etc.
4) Run Terraform init, plan, apply.
