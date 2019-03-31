provider "aws" {
  region = "${var.region}"
  profile = "${var.profile}"
  allowed_account_ids = ["${var.profile}"]
}