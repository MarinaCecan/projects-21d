#! /bin/bash -e

cp -r /opt/config/* /var/jenkins_home
sh /var/jenkins_home/scripts/create-user.sh
sh /var/jenkins_home/scripts/token.sh
sh /var/jenkins_home/scripts/regex.sh

/usr/local/bin/jenkins.sh
