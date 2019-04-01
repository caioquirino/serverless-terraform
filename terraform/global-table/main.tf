module "tables-us-east-1" {
  source = "./table"
  providers = {
    aws = "aws.us-east-1"
  }
  environment = "${var.environment}"
}

module "tables-eu-central-1" {
  source = "./table"
  providers = {
    aws = "aws.eu-central-1"
  }
  environment = "${var.environment}"
}

resource "aws_dynamodb_global_table" "users-global" {
  depends_on = [
    "module.tables-us-east-1",
    "module.tables-eu-central-1"
  ]
  provider = "aws.eu-central-1"

  name = "${var.environment}_users"

  replica {
    region_name = "us-east-1"
  }

  replica {
    region_name = "eu-central-1"
  }
}
