#!/usr/bin/env bash
set -e

cd `dirname "$(realpath $0)"`/..
BASEDIR=$PWD

source commonvars.sh

npm install
rm -rf serverless-terraform.zip
zip -rv serverless-terraform.zip src/* node_modules

function deploy_service {
  cd $BASEDIR/terraform/service
  region=$1
  TF_DATA_DIR=.terraform_$region terraform plan -var-file config/dev/$region/config.remote -var-file config/dev/$region/terraform.tfvars
  TF_DATA_DIR=.terraform_$region terraform apply -var-file config/dev/$region/config.remote -var-file config/dev/$region/terraform.tfvars -auto-approve
}
deploy_service us-east-1
deploy_service eu-central-1
