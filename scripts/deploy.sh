#!/usr/bin/env bash
cd `dirname "$(realpath $0)"`/..
BASEDIR=$PWD

npm install
rm -rf serverless-terraform.zip
zip -rv serverless-terraform.zip src/* node_modules

cd $BASEDIR/terraform/service
terraform plan -var-file config/dev/us-east-1/config.remote -var-file config/dev/us-east-1/terraform.tfvars -out plan.out
terraform apply -var-file config/dev/us-east-1/config.remote -var-file config/dev/us-east-1/terraform.tfvars -state plan.out -auto-approve
rm plan.out

cd $BASEDIR/terraform/dns
terraform plan -var-file config/dev/config.remote -var-file config/dev/terraform.tfvars -out plan.out
terraform apply -var-file config/dev/config.remote -var-file config/dev/terraform.tfvars -state plan.out -auto-approve
rm plan.out
