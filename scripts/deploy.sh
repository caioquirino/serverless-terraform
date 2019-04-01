#!/usr/bin/env bash
set -e

cd `dirname "$(realpath $0)"`/..
BASEDIR=$PWD

npm install
rm -rf serverless-terraform.zip
zip -rv serverless-terraform.zip src/* node_modules


cd $BASEDIR/terraform/global-table
# Edit config/dev/us-east-1/config.remote and put the correct profile, s3 state bucket and dynamodb lock table
terraform plan -var-file=config/dev/config.remote -var-file=config/dev/terraform.tfvars
terraform apply -var-file=config/dev/config.remote -var-file=config/dev/terraform.tfvars -auto-approve


function deploy_service {
  cd $BASEDIR/terraform/service
  region=$1
  TF_DATA_DIR=.terraform_$region terraform plan -var-file config/dev/$region/config.remote -var-file config/dev/$region/terraform.tfvars
  TF_DATA_DIR=.terraform_$region terraform apply -var-file config/dev/$region/config.remote -var-file config/dev/$region/terraform.tfvars -auto-approve
}
deploy_service us-east-1
deploy_service eu-central-1

cd $BASEDIR/terraform/dns
terraform init -backend-config=config/dev/config.remote
terraform plan -var-file config/dev/config.remote -var-file config/dev/terraform.tfvars
terraform apply -var-file config/dev/config.remote -var-file config/dev/terraform.tfvars -auto-approve
rm plan.out
