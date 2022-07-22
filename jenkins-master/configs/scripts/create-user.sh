#!/bin/bash

user=$(echo $username)
pass=$(echo $password)
ro_user=$(echo $rouser)
ro_pass=$(echo $ropassword)


sed -i "s|admin|${user}|g" /var/jenkins_home/init.groovy.d/basic-security.groovy
sed -i "s|password|${pass}|g" /var/jenkins_home/init.groovy.d/basic-security.groovy

sed -i "s|ro_user|${ro_user}|g" /var/jenkins_home/init.groovy.d/basic-security.groovy
sed -i "s|ro_pass|${ro_pass}|g" /var/jenkins_home/init.groovy.d/basic-security.groovy
