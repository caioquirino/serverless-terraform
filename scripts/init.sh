#!/usr/bin/env bash
cd `dirname "$(realpath $0)"`/..

npm install
cd terraform
terraform init -backend-config=config/dev/us-east-1/config.remote
# Edit config/dev/us-east-1/config.remote and put the correct profile, s3 state bucket and dynamodb lock table
terraform plan -var-file config/dev/us-east-1/config.remote
