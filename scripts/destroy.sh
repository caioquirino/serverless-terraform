#!/usr/bin/env bash
set -e

cd `dirname "$(realpath $0)"`/..
BASEDIR=$PWD

source commonvars.sh

function destroy_service {
  cd $BASEDIR/terraform/service
  region=$1
  TF_DATA_DIR=.terraform_$region terraform destroy -var-file config/dev/$region/config.remote -var-file config/dev/$region/terraform.tfvars -auto-approve
}
destroy_service us-east-1
destroy_service eu-central-1
