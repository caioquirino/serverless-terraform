#!/usr/bin/env bash
cd `dirname "$(realpath $0)"`/..
npm install
rm -rf serverless-terraform.zip
zip -rv serverless-terraform.zip src/* node_modules

cd terraform/service
terraform plan -var-file config/dev/us-east-1/config.remote
terraform apply -var-file config/dev/us-east-1/config.remote
