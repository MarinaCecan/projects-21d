# AWS EKS Terraform module

Terraform module which creates Kubernetes cluster resources on AWS EKS.

## Prerequisites
- AWS CLI
- kubectl

## Features
- Create an EKS cluster version 1.21
- Self-managed worker-nodes
- S3 backend and DynamoDB lock
- Mix of On-demand and Spot instances
- Mix of different instance types similar to t3/a.medium
- Autoscaling should be Multi-AZ
- VPC EKS with 3x public subnets and 3x private subnets

## Resources

#### Network
- aws_vpc.eks_vpc
- aws_subnet.eks_private_subnet
- aws_subnet.eks_public_subnet
- aws_internet_gateway.eks_igw
- aws_route_table.eks_public_rt
- aws_route_table_association.eks_rt

#### IAM roles
- aws_iam_role.eks_cluster
- aws_iam_role.worker_nodes
- aws_iam_role_policy_attachment.cluster_amazonEKSClusterPolicy
- aws_iam_role_policy_attachment.cluster_amazonEKSServicePolicy
- aws_iam_role_policy_attachment.cluster_amazonEKSVPCResourceController
- aws_iam_role_policy_attachment.worker_AmazonEKS_CNI_Policy
- aws_iam_role_policy_attachment.worker_amazonEC2ContainerRegistryReadOnly
- aws_iam_role_policy_attachment.worker_amazonEKSWorkerNodePolicy

#### Security Groups
- aws_security_group.cluster
- aws_security_group.worker-nodes
- aws_security_group_rule.cluster-egress
- aws_security_group_rule.cluster-ingress-workstation-https
- aws_security_group_rule.worker-egress
- aws_security_group_rule.workers-ssh
- aws_security_group_rule.workers-to-cluster
- aws_security_group_rule.workers-to-communicate

#### Cluster and self-managed worker-nodes
- aws_eks_cluster.selected
- eks_self_managed_node_group
- aws_launch_template.eks_self_managed_nodes
- aws_autoscaling_group.eks_self_managed_node_group

#### Backend
- aws_dynamodb_table.tf_remote_state_locking

## Important note
After running the code next steps to join the cluster:
1. Update kubeconfig file:
   - aws eks update-kubeconfig --region "   " --name "   " 
2. Create AWS authorization config map to allow the worker-nodes join the cluster. 
   Update the aws-auth-cm.yaml with IAM role arn of worker-nodes and run:
   - kubeclt apply -f aws-auth-cm.yaml.
