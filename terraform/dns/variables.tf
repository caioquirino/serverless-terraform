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

variable "base_domain" {
  description = "Base Domain"
}

variable "latency_dns_hosts" {
  type = "list"
  description = "A list of all hosts which may have traffic routed to. Example: ['gift-codes-access-dev-eu-central-1.dazndev.com']"
}

variable "latency_dns_regions" {
  type = "list"
  description = "A list describing where each of the 'latency_dns_hosts' specified above are hosted. Example: ['eu-central-1']"
}

variable "certificate_arns" {
  type = "map"
  description = "Domain certificate arn"
}

variable "api_gateway_name" {
  description = "API Gateway name"
}
