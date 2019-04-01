
variable "base_domain" {
  description = "Base Domain"
}

variable "environment" {
  description = "Environment - dev, prod..."
}

variable "region" {
  description = "AWS Region"
}

variable "certificate_arn" {
  description = "Domain certificate arn"
}

variable "api_gateway_name" {
  description = "API Gateway name"
}


variable "zone_id" {
  description = "Domain zone id"
}
