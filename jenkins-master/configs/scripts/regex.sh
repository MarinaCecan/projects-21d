#!/bin/bash

jobname=$(echo $jobname)
branchname=$(echo $branchname)
reponame=$(echo $reponame)
repoowner=$(echo $repoowner)

sed -i "s|JOBNAME|${jobname}|g" /var/jenkins_home/jobs/test-job/config.xml
sed -i "s|BRANCHNAME|${branchname}|g" /var/jenkins_home/jobs/test-job/config.xml
sed -i "s|REPONAME|${reponame}|g" /var/jenkins_home/jobs/test-job/config.xml
sed -i "s|REPOOWNER|${repoowner}|g" /var/jenkins_home/jobs/test-job/config.xml
