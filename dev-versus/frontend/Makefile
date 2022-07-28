repo = versus-frontend
account = $(shell aws sts get-caller-identity --query "Account" --output text)
stage = dev
include stage-configs/$(stage)

build:
	@docker build -t $(repo):$(version) .

login:
	@aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $(account).dkr.ecr.us-east-1.amazonaws.com

push: login
	@docker tag $(repo):$(version) $(account).dkr.ecr.us-east-1.amazonaws.com/$(repo):$(version)
	@docker push $(account).dkr.ecr.us-east-1.amazonaws.com/$(repo):$(version)
deploy:
	@cat namespace.yaml | sed "s/NAMESPACE/$(namespace)/g" | kubectl apply -f -
	@cat frontend-deployment.yaml | sed "s/IMAGEVERSION/$(version)/g;s/ACCOUNT/$(account)/g" | kubectl -n $(namespace) apply -f -
	@cat frontend-service.yaml | sed "s/NAMESPACE/$(namespace)/g" | kubectl apply -f - 
	@cat ingress.yaml | sed "s/NAMESPACE/$(namespace)/g" | kubectl apply -f - 
delete: 
	@cat ingress.yaml | sed "s/NAMESPACE/$(namespace)/g" | kubectl delete -f -
	@cat frontend-service.yaml | sed "s/NAMESPACE/$(namespace)/g" | kubectl delete -f -
	@cat frontend-deployment.yaml | sed "s/IMAGEVERSION/$(version)/g;s/ACCOUNT/$(account)/g" | kubectl -n $(namespace) delete -f -
	@cat namespace.yaml | sed "s/NAMESPACE/$(namespace)/g" | kubectl delete -f - --ignore-not-found 
