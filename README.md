## **Creating Amazon EKS cluster on AWS with a newly created VPC using Terraform**.

### **A Terraform module to create an Amazon Web Services (AWS) EKS cluster**

---

Amazon EKS is a managed service that helps make it easier to run Kubernetes on AWS. Through EKS, organizations can run Kubernetes without installing and operating a Kubernetes control plane or worker nodes.

>**Usage:**

To run this EKS cluster you need to execute in "eks-cluster-ubuntu" directory:
- terraform init
- terraform plan
- terraform apply

To configure kubectl:
- aws eks kubeconfig-update --region us-east-1 --name eks-cluster

Note:- Above command should setup kubeconfig file in ~/.kube/config in your system.


In order to configure the underlying Kubernetes cluster to allow worker nodes to join the cluster and add additional roles/users/accounts:
- kubectl apply -f aws-auth-cm.yaml


To see if working nodes joined cluster:
- kubectl get nodes


In order to install Nginx Ingress Controller:
- kubectl apply -f __[k8s-ingress.yaml](https://aws.amazon.com/premiumsupport/knowledge-center/eks-unhealthy-worker-node-nginx/)__

---

>### Resources that will be created:

- AWS VPC (Virtual Private Cloud).
- Three public and three private Subnets in different availability zones.
- Internet Gateway to provide internet access for services within VPC.
- Routing Tables and associate subnets with them. Adding required routing rules.
- Security Groups and associate subnets with them. Adding required routing rules.
- A Kubernetes Cluster, based on Spot and On-Demand EC2 instances running in public Subnets, with an Autoscaling Group.
- Terraform backend to specify the location of the backend Terraform state file on S3 (S3 have to be created before running this code).
- An Application Load Balancer (ALB) to accept public HTTP calls and route them into Kubernetes nodes.
- An AWS Load Balancer Controller inside the Cluster, to receive & forward HTTP requests from the outside world into Kubernetes pods.

<img width="602" alt="Screen Shot 2022-06-02 at 2 37 43 PM" src="https://user-images.githubusercontent.com/60176670/171769042-5eaaa64d-9886-4515-adff-b22138169a90.png">

### File structure:
```
└── eks-cluster-ubuntu
    ├── README.md
    ├── aws-auth-cm.yaml
    ├── eks-cluster
    │   ├── autoscaling.tf
    │   ├── eks.tf
    │   ├── iam-eks.tf
    │   ├── iam-nodes.tf
    │   ├── launch_template.tf
    │   ├── oidc.tf
    │   ├── outputs.tf
    │   ├── sg.tf
    │   ├── vars.tf
    │   └── vpc-network.tf
    ├── k8s-ingress.yaml
    ├── main.tf
    ├── outputs.tf
    ├── provider.tf
    ├── s3-backend.tf
    └── vars.tf
```
>The "eks-cluster-ubuntu" is a main directory which contains all the files to create EKS cluster.

>There are root module in "main.tf" file, and child modules in "eks-cluster" directory. 

> Child module consist of:
- "vpc-network.tf" file which creates VPC with all required components.
- "autoscaling.tf" file creates Auto Scaling group with both On-demand and Spot instances.
- "eks.tf" file creates EKS cluster in public subnets.
- "iam-eks.tf" file creates Role with the needed permissions that Amazon EKS will use to create AWS resources for Kubernetes clusters and interact with AWS APIs.
- "iam-nodes.tf" create IAM role for node group with needed permissions for the node group to communicate with other AWS services.
- "launch_template.tf" file will create launch template to be used by Auto Scaling group.
- __["oidc.tf"](https://aws.amazon.com/blogs/containers/introducing-oidc-identity-provider-authentication-amazon-eks/)__ allows to integrate an OIDC identity provider with a new Amazon EKS cluster running Kubernetes.
- "outputs.tf" contains output values which will be used to connect with cluster.
- "sg.tf" file creates 2 security groups: one for Control Plane another one for Worker Nodes.
- "vars.tf" file contains variables which is used for creating EKS cluster and above resources.

> The "s3-backend.tf" file dispatches terraform state file to s3-bucket in AWS.

> Root module variables are in "vars.tf".

> The "outputs.tf" file in root module reflects output values in child module.

> "provider.tf" file keep cloud provider information.

### Output values which will be used to connect to EKS cluster:
| Resource                     | Description |
| ---------------------------- | ----------- |
|   __[cluster_endpoint](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html)__           | Enable private access for your Amazon EKS cluster |
| __[oidc](https://aws.amazon.com/blogs/containers/introducing-oidc-identity-provider-authentication-amazon-eks/)__                         | Manage user access to your cluster


>#### Steps shortly:

1. Defined remote backend tf files for S3 bucket.
2. In the separate folder I have defined resources needed for EKS cluster, I separated them into 3 groups:
	- Networking
		- creation of my vpc, public and private subnets, internet, NAT gateways, route tables and route table associations
	- Eks cluster
		- eks cluster role, policy attachments, master node sg and eks cluster itself
	- Eks worker nodes
		- worker node role, policy attachments, instance profile, security groups with inbound and outbound rules, ami, bootstrap user data, launch template, autoscaling group with mix instance policy.
4. There are 2 ways to configure aws-auth configmap.tf (need to add worker nodes to the EKS cluster):
        - define define aws-auth configmap.tf , which will create a configmap.yaml. 
        - Or kubectl apply configmap.yaml file.
5. Then I have created main.tf file, where I have defined provider, terraform backend for statefile and module itself with the source directory.


### References:

- Terraform Registry https://registry.terraform.io
- AWS Documentation https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html
- Identity and access management https://aws.github.io/aws-eks-best-practices/security/docs/iam/
- Getting started with Kubernetes provider https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/guides/getting-started
- Terraform module to create EKS cluster https://github.com/terraform-aws-modules
- Amazon EKS Troubleshooting https://docs.aws.amazon.com/eks/latest/userguide/troubleshooting.html#worker-node-fail
- Deploy Nginx Ingress Controller https://aws.amazon.com/premiumsupport/knowledge-center/eks-access-kubernetes-services/
- Automate IAM Role Mapping on Amazon EKS https://www.ahead.com/resources/automate-iam-role-mapping-on-amazon-eks/
- Overall explanation of AWS EKS cluster https://antonputra.com/terraform/how-to-create-eks-cluster-using-terraform/
- IAM JSON to Terraform HCL https://flosell.github.io/iam-policy-json-to-terraform/

