environment          = "dev"
account              = "779725955043"
api_gateway_name     = "serverless-terraform-dev"

base_domain = "adventuretime.name"

certificate_arns = {
  "eu-central-1" = "arn:aws:acm:eu-central-1:779725955043:certificate/3fb05b5f-eeea-46b9-9c89-9e0bd48da8ac"
  "us-east-1"    = "arn:aws:acm:us-east-1:779725955043:certificate/ae826c8a-d4ef-47e6-9505-7fc023e30f4f"
}

latency_dns_hosts = [
  "eu-central-1.dev.adventuretime.name",
  "us-east-1.dev.adventuretime.name",
]

latency_dns_regions = [
  "eu-central-1",
  "us-east-1",
]
