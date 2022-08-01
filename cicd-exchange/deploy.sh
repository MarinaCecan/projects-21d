#!/bin/bash
set -xe

if [[ $BRANCH_NAME == cicd-exchange ]]
then 
    stage=dev
elif [[ $BRANCH_NAME == prod ]]
then 
    stage=prod
fi

if [[ $stage == dev ]]
then
    cd api/
    make build stage=$stage
    make push stage=$stage
    cd ..
    cd web/
    make build stage=$stage
    make push stage=$stage
    cd ..
fi


cd api/
make login
make deploy stage=$stage
cd ..
cd web/
make deploy stage=$stage
cd ..
