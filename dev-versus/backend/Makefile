repo = versus-backend
account = $(shell aws sts get-caller-identity --query "Account" --output text)
stage = dev
include stage-configs/$(stage)

db_name = $(shell aws secretsmanager --region us-east-1 get-secret-value --secret-id db_name --version-stage AWSCURRENT --query 'SecretString' --output text | jq -r '.db_name' | base64)

db_host = $(shell aws secretsmanager --region us-east-1 get-secret-value --secret-id db_host --version-stage AWSCURRENT --query 'SecretString' --output text | jq -r '.db_host' | base64) 

db_port = $(shell aws secretsmanager --region us-east-1 get-secret-value --secret-id db_port --version-stage AWSCURRENT --query 'SecretString' --output text | jq -r '.db_port' | base64)

db_user = $(shell aws secretsmanager --region us-east-1 get-secret-value --secret-id db_user --version-stage AWSCURRENT --query 'SecretString' --output text | jq -r '.db_user' | base64)

db_password = $(shell aws secretsmanager --region us-east-1 get-secret-value --secret-id db_password --version-stage AWSCURRENT --query 'SecretString' --output text | jq -r '.db_password'| base64)

test: 
	@echo -ne "$(db_name)" | base64

build:
	@docker build -t $(repo):$(version) .

login:
	@aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(account).dkr.ecr.us-east-1.amazonaws.com

push: login
	@docker tag $(repo):$(version) $(account).dkr.ecr.us-east-1.amazonaws.com/$(repo):$(version)
	@docker push $(account).dkr.ecr.us-east-1.amazonaws.com/$(repo):$(version)
deploy:
	@cat namespace.yaml | sed "s/NAMESPACE/$(namespace)/g" | kubectl apply -f -
	@cat k8s-secrets-secrets-manager.yaml | sed "s/NAMESPACE/$(namespace)/g;s/db_name/$(db_name)/g;s/db_user/$(db_user)/g;s/db_password/$(db_password)/g;s/db_host/$(db_host)/g;s/db_port/$(db_port)/g" | kubectl apply -f - 
	@cat versus-backend-deployment.yaml | sed "s/IMAGEVERSION/$(version)/g;s/ACCOUNT/$(account)/g" | kubectl -n $(namespace) apply -f -
	@cat backend-service.yaml | sed "s/NAMESPACE/$(namespace)/g" | kubectl apply -f - 
	@cat ingress.yaml | sed "s/NAMESPACE/$(namespace)/g" | kubectl apply -f -

delete: 
	@cat versus-backend-deployment.yaml | sed "s/IMAGEVERSION/$(version)/g;s/ACCOUNT/$(account)/g" | kubectl -n $(namespace) delete -f -
	@cat backend-service.yaml | sed "s/NAMESPACE/$(namespace)/g" | kubectl delete -f - 
	@cat ingress.yaml | sed "s/NAMESPACE/$(namespace)/g" | kubectl delete -f - 
	@cat k8s-secrets-secrets-manager.yaml | sed "s/NAMESPACE/$(namespace)/g" | kubectl delete -f -
	@cat namespace.yaml | sed "s/NAMESPACE/$(namespace)/g" | kubectl delete -f - --ignore-not-found
