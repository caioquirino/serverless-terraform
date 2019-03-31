#!/usr/bin/env bash
cd `dirname "$(realpath $0)"`/..

cd terraform/service
terraform destroy -var-file config/dev/us-east-1/config.remote
