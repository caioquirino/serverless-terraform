data "aws_api_gateway_rest_api" "api" {
  name = "${var.api_gateway_name}"
}

resource "aws_api_gateway_domain_name" "apigw_domain" {
  domain_name              = "${var.region}.${var.environment}.${var.base_domain}"
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
  zone_id = "${var.zone_id}"

  alias {
    evaluate_target_health = true
    name                   = "${aws_api_gateway_domain_name.apigw_domain.regional_domain_name}"
    zone_id                = "${aws_api_gateway_domain_name.apigw_domain.regional_zone_id}"
  }
}


//Repeated in order to have both regional and global Custom Domain Names registered in API GW
resource "aws_api_gateway_domain_name" "apigw_domain_global" {
  domain_name              = "${var.environment}.${var.base_domain}"
  regional_certificate_arn = "${var.certificate_arn}"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_base_path_mapping" "api_gateway_dns_map_global" {
  api_id      = "${data.aws_api_gateway_rest_api.api.id}"
  stage_name  = "${var.environment}"
  domain_name = "${aws_api_gateway_domain_name.apigw_domain_global.domain_name}"
}
