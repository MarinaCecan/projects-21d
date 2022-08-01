repo = redhat-exchange-web
region = us-east-1
stage = dev
account = $(shell aws sts get-caller-identity --query "Account" --output text)
include stages/$(stage)

build:
	docker build -t $(repo):$(version) .

login:
	aws ecr get-login-password --region $(region) | docker login --username AWS --password-stdin $(account).dkr.ecr.$(region).amazonaws.com

push: login
	docker tag $(repo):$(version) $(account).dkr.ecr.$(region).amazonaws.com/$(repo):$(version)
	docker push $(account).dkr.ecr.$(region).amazonaws.com/$(repo):$(version)

deploy:
	cat kubernetes/deploy.yaml | sed 's/IMAGEVERSION/$(version)/g;s/ACCOUNT/$(account)/g;s/REPO/$(repo)/g;s/REGION/$(region)/g;s/HOSTNAME/$(hostname)/g' | kubectl apply -f -
	
