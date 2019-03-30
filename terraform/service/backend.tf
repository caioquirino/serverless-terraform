terraform {
  required_version = "0.11.13"
  backend "s3" {
    region = "us-east-1"
  }
}
