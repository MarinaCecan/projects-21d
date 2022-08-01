# Sample three tier app

This repo contains code for a Node.js multi-tier application.

The application overview is as follows

```
web <=> api <=> db
```

The folders `web` and `api` describe how to install and run each app.

#notes how to apply

- manually create ecr or run tf code ecr-creation.tf (names are hardcoded). Add permissions to allow push from EKS to ECS(go to eks=>configuration=>detailes=>Cluster iam role=>(redirested to iam page) add permission policies=>add "amazonEc2ContainerRegistry full access)
- manually create dns records with A record to the NLB of our EKS cluster. Get load balancer's arn from console
- connect Jenkins to the repo (currently dev==312-bc/exchange-21d-redhat/ and filtered by the branch name ci/cd-exchange from console)
- update Jenkinsfile to have webhook. If not updated, currently checks for update every 5 mins.
- enjoy your builds.

`exchange-web` app dev ==> http://dev-21dcentos.exchangeweb.net/

`exchange-web` prod ==> http://prod-21ccentos.exchangeweb.net/

#Steps to containerize exchange-app and set up ci/cd with Jenkins.


1. Application contains 3 tiers, this explaines 2 tiers, web and api. Referred as web-exhange and api-exchange.

2. Create Dockerfile for each tier, web-exchange Dockerfile and api-exchange Dockerfile. Follow instructions in readme.md in each tier(env vars and npm install)

3. Create Makefile for each tier.

3.1. Makefile should build, login and push newly created image to ECR. Those commands can be found in aws-console at the repo settings. Copy them, and paste them in makefile ==> substitute things that might change, and set environment variables for them(account,repo,region,version)
3.2. Create a folder with files for stages(dev and prod). Set up env that will change between stages, like hostname in our case.
3.3. Include that folder in Makefile "include stages/$(stage)" where stage=<dev_or_prod> in the beginning of our Makefile.

4. Create folder for k8s deployment files. Create deployment and service for it (deploy.yaml). ClusterIp in both tiers, since we will be using Ingress nginx for external access.

4.1. /api/kubernetes/deploy.yaml ==> requires env var of database for it and port to connect to db. Database url - in current app specified in ./api/app.js file and equals to "postgres://username:password@localhost/database". Created an aws-secrets-manager secret from console that equals "url":"postgres://username:password@localhost/database", and query it in a Makefile for api as var. Then in make-deploy, create k8s secret imperatively and refer to this env. 
4.2. /web/kubernetes/deploy.yaml ==> requires env var of api-exchange and port to connect. "http://exchange-api-svc:80"-this a url to call exchange-api, clusterIP-link and port since we will be calling in internally. Create ingress.yaml for this deployment with a kind: Ingress. Update Makefile to apply ingress.yaml.
4.3. for image in both deployments, substitute account_number, region, repo, version with words that will be changed with cat and sed in makefile. to simplify for future configurations. set up those as env in Makefile (/api/Makefile and /web/Makefile)

5. Update makefile to apply kubernetes file. use sed for all env in previous task. For example, substitute word ACCOUNT in deploy.yaml to the $(account), that is specified in the same Makefile.

6. cd .. (to work outside the tier-folders, with Jenkinsfile)

7. Create file deploy.sh to refer in Jenkins. 

8. Jenkinsfile. Create and add Trigger for pipeline. properties([ \pipelineTriggers([ ]) ])

9. deploy.sh ==> script that defines stages. Uses $BRANCH_NAME env - specific by Jenkins, not by us. Script runs all the Makefile commands for dev environment, and for PROD it only run "make deploy" for each tier, as the image should be already tested and pushed in testing(dev).


Useful links:
Secrets=>
https://github.com/312-bc/devops-tools/blob/master/bin/aws-secretsmanager-create-secrets
https://github.com/312-bc/devops-tools/blob/master/bin/k8s-secrets-inject-secrets

#Issues
- must have enough resources. Nodes crashed if overloaded, so created resource limit in k8s deployment and in Jenkinsfile(ephemeral storage - overloaded with logs.)
- where to find env for db-url requirements (./api/app.js)
- how to implement secret in k8s from aws console - create a secret from console that would look like required url(postgres://user:password@localhost/db) with information from parameter store. 
- pushing image to ecr - eks should have permission policies attached (AmazonEc2ContainerRegistryFullAccess)

diagram ==> https://docs.google.com/drawings/d/16qv0JyjmKoL-vSoM9rq76YIQwY2T0ZDo5yN52MakS0A/edit?usp=sharing
