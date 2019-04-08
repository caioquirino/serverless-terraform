#!/usr/bin/env bash
cd `dirname "$(realpath $0)"`/..
BASEDIR=$PWD

source commonvars.sh

npm install

cd $BASEDIR/terraform/service
# Edit config/dev/us-east-1/config.remote and put the correct profile, s3 state bucket and dynamodb lock table
TF_DATA_DIR=.terraform_us-east-1 terraform init -backend-config=config/dev/us-east-1/config.remote
TF_DATA_DIR=.terraform_eu-central-1 terraform init -backend-config=config/dev/eu-central-1/config.remote
