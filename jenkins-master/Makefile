#Variables

name=jenkins-master
region=us-east-1
version=latest
namespace=default
account=$(shell aws sts get-caller-identity --output text --query 'Account')
image=$(account).dkr.ecr.$(region).amazonaws.com/$(name):$(version)

# Jenkins users vars

secretname=jenkins-master-admin2
ro-secretname=jenkins-master-ro2

# vars for sed replacement in config job

job-creds=jenkins-master-secrets

#vars for personal access token

pat-jenkins=pat-jenkins-master

# creates secret for admin user and ro-user

secret:
	@aws secretsmanager create-secret --name $(secretname) \
	--description "admin credentials for jankins-master" \
	--secret-string file://admin-user.json
	
	@aws secretsmanager create-secret --name $(ro-secretname) \
	--description "read-only user credentials for jankins-master" \
	--secret-string file://ro-user.json

        #@rm admin-user.json ro-user.json



# Retrieves username for admin user from AWS Secrets Manager

get-secret-username=$(shell aws secretsmanager get-secret-value --secret-id jenkins-master-admin2 \
        --version-stage AWSCURRENT --query 'SecretString' --output text | jq -r '.username' | base64)

# Retrieves password for admin user from AWS Secrets Manager 

get-secret-password=$(shell aws secretsmanager get-secret-value --secret-id jenkins-master-admin2 \
        --version-stage AWSCURRENT --query 'SecretString' --output text | jq -r '.password' | base64)

# Retrieves username for ro-user from AWS Secrets Manager

get-secret-ro-username=$(shell aws secretsmanager get-secret-value --secret-id jenkins-master-ro2 \
        --version-stage AWSCURRENT --query 'SecretString' --output text | jq -r '.username' | base64)

# Retrieves password for ro-user from AWS Secrets Manager 

get-secret-ro-password=$(shell aws secretsmanager get-secret-value --secret-id jenkins-master-ro2 \
        --version-stage AWSCURRENT --query 'SecretString' --output text | jq -r '.password' | base64)

# Retrieves personal access token from AWS Secrets Manager 

get-token=$(shell aws secretsmanager get-secret-value --secret-id pat-jenkins-master \
        --version-stage AWSCURRENT --query 'SecretString' --output text | base64)

# Retrieves jobname secret

get-jobname=$(shell aws secretsmanager get-secret-value --secret-id jenkins-master-secrets \
        --version-stage AWSCURRENT --query 'SecretString' --output text | jq -r '.jobname' | base64)

# Retrieves branchname

get-branchname=$(shell aws secretsmanager get-secret-value --secret-id jenkins-master-secrets \
        --version-stage AWSCURRENT --query 'SecretString' --output text | jq -r '.branchname' | base64)

# Retrieves repoowner from AWS Secrets Manager

get-repoowner=$(shell aws secretsmanager get-secret-value --secret-id jenkins-master-secrets \
        --version-stage AWSCURRENT --query 'SecretString' --output text | jq -r '.repoowner' | base64)

# Retrieves reponame from AWS Secrets Manager

get-reponame=$(shell aws secretsmanager get-secret-value --secret-id jenkins-master-secrets \
        --version-stage AWSCURRENT --query 'SecretString' --output text | jq -r '.reponame' | base64)




# login ECR repository

login:
	@aws ecr get-login-password --region $(region) | docker login \
	--username AWS --password-stdin $(account).dkr.ecr.$(region).amazonaws.com



# build the image 

build:
	@docker build -t $(image) .

# push the image to ECR

push: login build
	@docker push $(image)

# install jenkins-master on EKS cluster

replace-secret:
	@cat secret-jenkins-master.yaml | sed "s|USERNAME|$(get-secret-username)|g;s|PASSWORD|$(get-secret-password)|g;s|ROUSER|$(get-secret-ro-username)|g;s|ROPASS|$(get-secret-ro-password)|g;s|PAT|$(get-token)|g;s|DISPLAYNAME|$(get-jobname)|g;s|BRANCHNAME|$(get-branchname)|g;s|REPOOWNER|$(get-repoowner)|g;s|REPONAME|$(get-reponame)|g" | kubectl apply -f -


# add additional permissions to pod 

permission:
	@kubectl apply -f cluster-role-binding.yaml
	@kubectl apply -f psp.yaml

install: replace-secret permission
	@kubectl apply -f svc-sc-ig.yaml	
	@cat jenkins-statefulset.yaml | sed "s|ACCOUNT|$(account)|g;s|VERSION|$(version)|g;s|REGION|$(region)|g;s|NAME|$(name)|g" | kubectl apply -f -



# delete everything 

delete:
	@kubectl delete -f jenkins-statefulset.yaml
	@kubectl delete pvc $$(kubectl get pvc | awk '{print $1}' | grep jenkins-home)
