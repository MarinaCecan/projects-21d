#!bin/bash

pat_token=$(echo $token)

sed -i "s|TOKEN|${pat_token}|g" /var/jenkins_home/credentials.xml 
