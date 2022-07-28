# VERSUS APP

![VS](https://graphicriver.img.customer.envatousercontent.com/files/266600717/Versus%20Sign%20with%20Lightning%20background%20drawn%20in%20comics%20style.%20Vector%20illustration_pw.jpg?auto=compress%2Cformat&q=80&fit=crop&crop=top&max-h=8000&max-w=590&s=f727cf8e7e0541f9486786d6ec85c8ef)

Versus was launched in 2012 with the purpose of helping users make informed buying decisions through objective, fact-based comparisons. The initial focus was on tech products but then it expanded on to other categories, such as apps, cities, universities, and nutrition. Versus now covers over 7 million comparisons, available in 15 languages. The main objective is to help us make the right decision by providing accurate and fact based information. 

## Backend Installation Instructions 

### Data migration to the RDS MySQL Database

We are going to use an Ubuntu server in order to migrate the data that populates the backend of the Database. 
- Create an instance with Ubuntu OS and install the following:

The prerequisities for Python build:
```
sudo apt-get update
sudo apt-get install --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev 
```

Install pyenv:
[Instructions to install pyenv](https://www.liquidweb.com/kb/how-to-install-pyenv-on-ubuntu-18-04/)

Pyenv is a fantastic tool for installing and managing multiple Python versions. It enables a developer to quickly gain access to newer versions of Python and keeps the system clean and free of unnecessary package bloat. It also offers the ability to quickly switch from one version of Python to another, as well as specify the version of Python a given project uses and can automatically switch to that version.

Install Python: 
```
pyenv install 3.7.4
```

The main advantage of virtual environments is that they constitute a separate workspace (virtualenv) for each of your projects. The packages installed in these workspaces won’t interfere with each other, so that you can safely install, upgrade or remove libraries without affecting other projects.

Install pyenv-virtualenv:

Run the following commands to install pyenv-virtualenv:
```
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv
echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
exec "$SHELL"
pyenv virtualenv 3.7.4 vs-api-venv
```

The last command will create a virtualenv with the name *vs-api-venv*. Virtualenv name *vs-api-venv* is important because .python-version also points to it. It is needed for virtualenv to be activated automatically when you enter project directory and deactivated when you leave.

We have to install the following prerequisites: 

```
sudo apt-get install python3-dev default-libmysqlclient-dev
```

In the activated virtualenv install requirements:

```
pip install -r requirements.txt
```

Install MySQL on Ubuntu, follow the instructions from the link below:
[Instructions to install MySQL](https://phoenixnap.com/kb/install-mysql-ubuntu-20-04)

**NOTE**: Make sure you have already created a MySQL RDS Database and have all the credentials ready!

Export the ENV credentials for the Database on the Ubuntu server by running the following commands and make sure to replace them with your values:

```
export MYSQL_DATABASE=xxxxx
export MYSQL_USER=admin
export MYSQL_PASSWORD=xxxxx
export MYSQL_HOST=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
export MYSQL_PORT=3306
```

Access the MySQL RDS from the Ubuntu server by running the following command (if you have a different username, make sure to change "admin"):
```
mysql -u admin -p
```
After you accessed MySQL RDS, create a new database inside by running the following command:

```
CREATE DATABASE versus CHARACTER SET utf8 COLLATE utf8_bin;
```

**NOTE**: Make sure that MySQL, Ubuntu server & the EKS cluster are on the same VPC!

After creating the Database, exit and run the following commands to migrate the data. Make sure you also clone the Github repository and are in the same directory where **manage.py** file is when you run the commands:

```
./manage.py migrate
./manage.py loaddata data.json
```

After it finishes successfully, you are all good to go on working on the application in Kubernetes.

Some of the useful links that might help with issues that come up:
[MySQL connection error](https://www.tecmint.com/fix-error-2003-hy000-cant-connect-to-mysql-server-on-127-0-0-1-111/)
[MySQL connection error](https://www.tecmint.com/fix-error-1130-hy000-host-not-allowed-to-connect-mysql/)
[MySQL error](https://stackoverflow.com/questions/1559955/host-xxx-xx-xxx-xxx-is-not-allowed-to-connect-to-this-mysql-server)



## Deploying in Kubernetes

1. First things first, clone the Github repository and make sure to convert docker-compose.yaml into Kubernetes in order to achieve the manifests files. We'll need the following Kubernetes Objects from the files obtained. 
- Backend Deployment 
- Backend Service 
- Frontend Deployment 
- Frontend Service 

```
kompose convert -f docker-compose.yml
```

[Install Kompose Convert](https://kompose.io/installation/)

2. Create 2 ECR repositories, one for the backend image and another one for the frontend image. 

3. Build the backend image from the Dockerfile and push it into the appropriate ECR repository. Edit the backend deployment manifest file with the container image. 

4. Create AWS Secrets with the RDS MySQL credentials. Extract the value of the encrypted value of the secret from AWS in the backend Makefile:

```
db_name = $(shell aws secretsmanager --region us-east-1 get-secret-value --secret-id db_name --version-stage AWSCURRENT --query 'SecretString' --output text | jq -r '.db_name' | base64)
```

4. Create a Kubernetes secret where the values of the variables can be replaced with the extracted values, in the follwing way:

```
@cat k8s-secrets-secrets-manager.yaml | sed "s/NAMESPACE/$(namespace)/g;s/db_name/$(db_name)/g;s/db_user/$(db_user)/g;s/db_password/$(db_password)/g;s/db_host/$(db_host)/g;s/db_port/$(db_port)/g" | kubectl apply -f -
```

The following technique is safer, because there are no sensitive credentials stored on the local machine or in the source code on GitHub. Everything is safely stored in Secrets Manager on AWS. 

5. Create an ingress & expose the backend service, as well as register the backend with the Route53 hosted zone, it will have the same name as the frontend ingress, JUST a different path. 

```
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  name: ingress-myserviceb
  namespace: NAMESPACE
  annotations:
    # use the shared ingress-nginx
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: versus-dev-21d-ubuntu.exchangeweb.net
    http:
      paths:
      - path: /api
        backend:
          serviceName: backend
          servicePort: 8000
```

6. Before building a frontend Docker image you should make appropriate changes in .env.production file in frontend folder. The .env.production file contains a REACT_APP_API_URL variable with a domain address.

```
REACT_APP_API_URL=http://versus-dev-21d-ubuntu.exchangeweb.net
```

7. Build the frontend image and push into ECR, and replace the container image with the one pushed into ECR. Create the frontend deployment & frontend service. 

8. Create the ingress resource for the frontend service and register it with Route53. 

```
apiVersion: networking.k8s.io/v1beta1
kind: Ingress
metadata:
  namespace: NAMESPACE
  name: ingress-versus
  annotations:
    # use the shared ingress-nginx
    kubernetes.io/ingress.class: "nginx"
spec:
  rules:
  - host: versus-dev-21d-ubuntu.exchangeweb.net
    http:
      paths:
      - path: /
        backend:
          serviceName: frontend
          servicePort: 3000
```

This is the link where you can find information on how to build an ingress controller and the ingress resources:
[Ingress-nginx Information](https://kubernetes.github.io/ingress-nginx/user-guide/basic-usage/)

After completing all the steps, you'll successfully see the Versus page in your browser! 

## Building the CI/CD with Jenkins 

If help is needed to install & configure Jenkins, please refer to these videos:
[Jenkins installation & configuration](https://www.youtube.com/watch?v=pMO26j2OUME&list=PLy7NrYWoggjw_LIiDK1LXdNN82uYuuuiC&index=1)

We will deploy our Versus application in 2 environments: Development and Production. We will be using namespaces to isolate the environments.

```
dev-versus
prod-versus
```

1. Create 2 Makefiles, one is for frontend and the second for backend, the Makefiles will include commands to:
- Build Docker images
- Log into the ECR
- Push them into the ECR
- Create all the Kubernetes objects mentioned above that are necessary to deploy the application. 
- Depending on the environment we will be deploying, it will create a namespace to isolate the resources based on the branch name. 
- Clean up

2. Create a script that will help Jenkins identify which environment to deploy into. 
- If $BRANCH_NAME == dev-*, deploy in Development if $BRANCH_NAME == prod, release into Production 
- We will also have to create stage-config files for Development and Production, which will include information on the image version and the namespace to be deployed in, for example:

```
version = 1.1
namespace = dev-versus
```

Below, you can see the deploy.sh script that generates the conditional logic for our Jenkins:

```
#!/bin/bash

set -x -e 

if [[ $BRANCH_NAME == dev-* ]]
then
    stage=dev
elif [[ $BRANCH_NAME == prod-* ]]
then
    stage=prod
fi

# if [[ $stage != prod ]]
if [[ $stage == dev ]]
then
    cd backend
    make build stage=$stage
    make push stage=$stage
    make deploy stage=$stage
    cd ..
    cd frontend/
    make build stage=$stage
    make push stage=$stage
    make deploy stage=$stage
    cd ..
elif [[ $stage == prod ]]
then
    cd backend
    make deploy stage=$stage
    cd ..
    cd frontend/
    make deploy stage=$stage
    cd ..
fi
```

3. Create the Jenkinsfile that will provide the necessary instructions for Jenkins and include deploy.sh to be executed. Before running the Jenkins job, make sure you have the necessary executable permissions for the script. This was one of the issues that I faced, but solved it with the help of the following resource:
[Jenkins script permission issues](https://localcoder.org/permission-denied-error-jenkins-shell-script)

4. Create a **Multibranch Pipeline** job and configure it appropriately. Make sure the name of the job matches the GitHub repository (it's just easier this way!). You can find information on how to configure the Multibranch Pipeline job in the link below:
[Multibranch Pipeline configuration](https://devopscube.com/jenkins-multibranch-pipeline-tutorial/)

5. So now we have a job that identifies 2 branches and has the logic to build based on the $BRANCH_NAME. To make the process more automated, we will configure Webhooks in the GitHub repository, so this way whenever a developer pushes the code in the dev-versus branch, the job automatically starts the build. The best practice is to set up reviewers that will approve your merges into the production branch. Once your Pull Requests are approved, the code gets pushed into the production branch and Jenkins starts deploying into production! 

To find out more information about the GitHub Webhooks please see the link below:
[GitHub Webhooks](https://www.blazemeter.com/blog/how-to-integrate-your-github-repository-to-your-jenkins-project)

Once Jenkins multibranch pipeline is all set, it will perform the job following the stages below:

1. **Checkout SCM(Source Code Management)**: Here Jenkins scans the GitHub Repository and identifies all the branches that exist and then based on the configurations that were implemented when creating the multibranch pipeline job, it will find the branch that it needs to get instructions from. 

2. **Cloning the Repository**: In the following stage Jenkins will clone the GitHub Repository and search for Jenkinsfile, in order to find the necessary instructions. In our case Jenkins identifies the Jenkinsfile which contains a script named **deploy.sh** with all the necessary logic in regards to what environment to deploy into. The script references instructions from the Makefiles - both backend and frontend, and they direct Jenkins to make build, make push and make deploy. 

3. **Build Image**: In this stage, Jenkins builds the image using the Dockerfile, it also displays all the steps that you would normally see when building a Docker image. It shows in details all the packages that are being installed and all of the dependencies. If by any means, something goes wrong, we will be able to see where it exactly failed so that the issue can be fixed. 

4. **Push Image into ECR**: This step implements "make push" which essentially contains instructions on how to log into the ECR and push the image, so that it will later be retrieved when creating the Kubernetes backend and frontend deployments. In the console, you will see if Jenkins successfully managed to log into the ECR or failed as well as if it was able to push the image or not. 

5. **Deploy Image**: Here Jenkins pulls the image from the ECR and creates the following Kubernetes objects: 
- The Namespace
- Backend Deployment 
- Backend Internal Service 
- Backend Ingress 
- Kubernetes Secret with the Database credentials 

6. It then repeats the same process for the frontend, and when it comes to the **Deploy Image** stage, it will create the following Kubernetes resources for the frontend:
- Frontend Deployment 
- Frontend Internal Service 
- Frontend Ingress


7. We can additionally set up a Post-build Action, to receive an email notification in case we received an error and our build was unstable. This linke will provide more information in regards to this: [Post-Build Action](https://www.youtube.com/watch?v=DULs4Wq4xMg&list=PLhW3qG5bs-L_ZCOA4zNPSoGbnVQ-rp_dG&index=13)

In Production, the steps that contains building the image and pushing it into ECR will be skipped, Jenkins will only retrieve the images from the ECR and deploy!

These are all the steps that I have implemented during the Jenkins job execution. 
