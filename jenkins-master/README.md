# Jenkins Master



![Logo](https://upload.wikimedia.org/wikipedia/commons/thumb/e/e3/Jenkins_logo_with_title.svg/2560px-Jenkins_logo_with_title.svg.png)


## What is Jenkins ?

Jenkins is a self-contained, open source automation server which can be used to automate all sorts of tasks related to building, testing, and delivering or deploying software.


Visit Jenkins Documentaion for more information about Jenkins:  
[Jenkins User Documentation](https://www.jenkins.io/doc/)

### Jenkins Master 
-----------------
The Jenkins master is in charge of scheduling the jobs, assigning slaves, and sending builds to slaves to execute the jobs. It'll also keep track of the slave state (offline or online) and retrieve the build result responses from slaves and display them on the console output.

### Jenkins master configured as code 
Setting up Jenkins is a complex process, as both Jenkins and its plugins require some tuning and configuration, with dozens of parameters to set within the web UI manage section.

Jenkins Configuration as Code provides the ability to define this whole configuration as a simple, human-friendly, plain text yaml syntax. Without any manual steps, this configuration can be validated and applied to a Jenkins controller in a fully reproducible way. With JCasC, setting up a new Jenkins controller will become a no-brainer event.

### - Kubertetes Resources
1. Deploy Jenkins Master StatefulSet
2. Create a PerssistentVolumeClaim
3. Create a Service
4. Create a ServiceAccount
5. Create Ingress
6. Create ClusterRoleBinding

----------------------

#### Configuring Jenkins manually through the UI
Once Jenkins is configured, all the configuration files will be stored inside the Jenkins pod under /var/jenkins_home.
* Coppy the files from /var/jenkins home to the location you need for futher modifications. 
 #### Dokerfile
 -------
 - Use the jenkins/jenkins as the base image and add all the plugins that you need.
 - After all the configuration files have been edited, copy them to some temporary folder first (ex: /config, not /var/jenkins), because when Jenkins master pod starts, it will overrite all files in that folder, this is how Persistent Volumes work.
 - Create a script that will run when jenkins starts (CMD or ENTRYPOINT), this script should copy the config files from the temporary location (ex: /config) to /var/jenkins_home.

 #### Makefile
 -----
 - Use enviroment variables for the Makefile so that it becomes reusable.
 - Create secrets using json files that will create secrets in AWS SecretsManager.
 - Retrive the secrets from AWS and encrypt them using base64 encryption method. 
 - Use sed replacement to insert the secrets in kubernetes secrets. 
    - You can also use scrips that will help you create, update and inject secrets. 
      [Link to secrets scrips in GitHub  ](https://github.com/312-bc/devops-tools/tree/master/services/grafana/bin)
- Login into AWS ECR, build the image with the new plugins and configurations and after that push it to AWS ECR.
- Insert the k8s secrets into Jenkins pod and build the new Jenkins with the new image. 

#### Groovy script 
-----------------
Groovy is a scripting language with Java-like syntax for the Java platform. The Groovy scripting language simplifies the authoring of code by employing dot-separated notation, yet still supporting syntax to manipulate collections, Strings, and JavaBeans.

- We will be using groovy script for creating users in Jenkins and give the users the permissions that they need.
- In our case we have an admin user and a read-only user.
 
### Useful resources:

- [Project: Declarative Configuration of Jenkins Hands-on session](https://canvas.312.school/courses/66/discussion_topics/2105)
- [Kubernetes Documentation ](https://kubernetes.io/)
- [Jenkins Documentation](https://www.jenkins.io/projects/jcasc/)
- [Example of groovy script creating Jenkins users](https://gist.github.com/wiz4host/17ab33e96f53d8e30389827fbf79852e)
