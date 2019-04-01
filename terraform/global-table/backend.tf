terraform {
  required_version = "0.11.13"
  backend "s3" {}
}

provider "aws" {
  region = "us-east-1"
  profile = "${var.profile}"
}

provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"
  profile = "${var.profile}"
}

provider "aws" {
  alias = "eu-central-1"
  region = "eu-central-1"
  profile = "${var.profile}"
}
