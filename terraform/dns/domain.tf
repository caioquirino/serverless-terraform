data "aws_route53_zone" "domain_zone" {
  name         = "${local.base_domain}."
  private_zone = false
}

resource "aws_route53_zone" "env_zone" {
  name         = "${var.environment}.${local.base_domain}"

  tags = {
    environment = "${var.environment}"
  }
}

resource "aws_api_gateway_domain_name" "apigw_domain" {
  domain_name              = "${var.environment}.${local.base_domain}"
  regional_certificate_arn = "${var.certificate_arn}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "api_gateway_dns_map" {
  api_id      = "${data.aws_api_gateway_rest_api.api.id}"
  stage_name  = "${var.environment}"
  domain_name = "${aws_api_gateway_domain_name.apigw_domain.domain_name}"
}

resource "aws_route53_record" "api_record" {
  name    = "${aws_api_gateway_domain_name.apigw_domain.domain_name}"
  type    = "A"
  zone_id = "${aws_route53_zone.env_zone.id}"

  alias {
    evaluate_target_health = true
    name                   = "${aws_api_gateway_domain_name.apigw_domain.regional_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.apigw_domain.regional_zone_id}"
  }
}
