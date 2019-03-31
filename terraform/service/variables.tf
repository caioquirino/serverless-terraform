# Run terraform plan -var-file=path/to/config.remote to get this properties

variable "key" {
  description = "Terraform State S3 Backend location."
}
variable "profile" {
  description = "AWS Profile in use. (preprod/prod)"
}
variable "region" {
  description = "AWS region in use."
}
variable "lambda_deploy_bucket" {
  description = "Lambda zip deployment file bucket name"
}

variable "environment" {
  description = "Environment - dev, prod..."
}
