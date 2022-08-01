account = $(shell aws sts get-caller-identity --query "Account" --output text)
repo = redhat-exchange-api
region = us-east-1
stage = dev
#query the secrets manager
secret = $(shell aws secretsmanager get-secret-value --secret-id exchange-db-cicd --query 'SecretString' --output text | jq -r '.url')
include stages/$(stage)

build:
	docker build -t $(repo):$(version) .

login:
	aws ecr get-login-password --region $(region) | docker login --username AWS --password-stdin $(account).dkr.ecr.$(region).amazonaws.com

push: login
	docker tag $(repo):$(version) $(account).dkr.ecr.$(region).amazonaws.com/$(repo):$(version)
	docker push $(account).dkr.ecr.$(region).amazonaws.com/$(repo):$(version)
deploy: login
#	aws secretsmanager get-secret-value --secret-id exchange-db-cicd --query 'SecretString' --output text | jq -r '.url'>secret.txt
#	kubectl create secret generic postgresql-url-new --from-file=secret.txt
	kubectl create secret generic postgresql-url-new --from-literal url=$(secret)
	cat kubernetes/deploy.yaml | sed "s/IMAGEVERSION/$(version)/g;s/ACCOUNT/$(account)/g;s/REPO/$(repo)/g;s/REGION/$(region)/g" | kubectl apply -f - 
