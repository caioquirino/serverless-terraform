data "aws_route53_zone" "domain_zone" {
  name         = "${var.base_domain}."
  private_zone = false
}

resource "aws_route53_health_check" "health" {
  count = "${length(var.latency_dns_hosts)}"
  fqdn = "${element(var.latency_dns_hosts, count.index)}"
  type = "HTTPS"
  port = "443"
  resource_path = "/health"
  failure_threshold = "5"
  request_interval = "30"
}

module "apigw_domain_us_east_1" {
  providers = {
    aws = "aws.us"
  }
  source = "./regional_apigw"
  base_domain = "${var.base_domain}"
  api_gateway_name = "${var.api_gateway_name}"
  certificate_arn = "${lookup(var.certificate_arns, "us-east-1")}"
  environment = "${var.environment}"
  zone_id = "${data.aws_route53_zone.domain_zone.id}"
  region = "us-east-1"
}


module "apigw_domain_eu_central_1" {
  providers = {
    aws = "aws.eu"
  }
  source = "./regional_apigw"
  base_domain = "${var.base_domain}"
  api_gateway_name = "${var.api_gateway_name}"
  certificate_arn = "${lookup(var.certificate_arns, "eu-central-1")}"
  environment = "${var.environment}"
  zone_id = "${data.aws_route53_zone.domain_zone.id}"
  region = "eu-central-1"
}


resource "aws_route53_record" "balanced_record" {
  name    = "dev.${var.base_domain}"
  type    = "CNAME"
  zone_id = "${data.aws_route53_zone.domain_zone.id}"
  set_identifier = "${format("%s-%s", "serverless_demo", element(var.latency_dns_regions, count.index))}"
  health_check_id = "${element(aws_route53_health_check.health.*.id, count.index)}"
  ttl = 30

  records = [
    "${element(var.latency_dns_hosts, count.index)}",
  ]

  latency_routing_policy {
    region = "${element(var.latency_dns_regions, count.index)}"
  }
}
