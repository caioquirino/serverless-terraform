# Run terraform plan -var-file=path/to/config.remote to get this properties

variable "key" {
  description = "Terraform State S3 Backend location."
}
variable "account" {
  description = "AWS Account ID"
}
variable "profile" {
  description = "AWS Profile in use. (preprod/prod)"
}
variable "region" {
  description = "AWS region in use."
}

variable "environment" {
  description = "Environment - dev, prod..."
}


variable "certificate_arn" {
  description = "Domain certificate arn"
}

variable "api_gateway_name" {
  description = "API Gateway name"
}
