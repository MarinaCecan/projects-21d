#!/bin/bash

kubectl delete deploy exchange-api exchange-web

kubectl delete secret postgresql-url-new

kubectl delete svc exchange-api-svc exchange-web-svc

aws ecr batch-delete-image --repository-name redhat-exchange-api --image-ids imageTag=v1

aws ecr batch-delete-image --repository-name redhat-exchange-web --image-ids imageTag=v1
