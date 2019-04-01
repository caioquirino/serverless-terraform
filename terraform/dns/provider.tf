provider "aws" {
  region = "${var.region}"
  profile = "${var.profile}"
  allowed_account_ids = ["${var.profile}"]
}

provider "aws" {
  alias  = "us"
  region = "us-east-1"
}
provider "aws" {
  alias  = "eu"
  region = "eu-central-1"
}
