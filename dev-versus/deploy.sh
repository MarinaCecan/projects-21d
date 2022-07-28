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
