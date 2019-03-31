resource "aws_api_gateway_rest_api" "api" {
  name = "serverless-terraform-${var.environment}"
}

resource "aws_api_gateway_resource" "allurls_resource" {
  path_part   = "{proxy+}"
  parent_id   = "${aws_api_gateway_rest_api.api.root_resource_id}"
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
}

resource "aws_api_gateway_method" "allurls_any_method" {
  rest_api_id   = "${aws_api_gateway_rest_api.api.id}"
  resource_id   = "${aws_api_gateway_resource.allurls_resource.id}"
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "allurls_integration" {
  rest_api_id             = "${aws_api_gateway_rest_api.api.id}"
  resource_id             = "${aws_api_gateway_resource.allurls_resource.id}"
  http_method             = "${aws_api_gateway_method.allurls_any_method.http_method}"
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.test_lambda.arn}/invocations"

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

resource "aws_api_gateway_deployment" "proxy_api" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${var.environment}"

  depends_on = [
    "aws_api_gateway_integration.allurls_integration"
  ]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_method_settings" "proxy_settings" {
  rest_api_id = "${aws_api_gateway_rest_api.api.id}"
  stage_name  = "${aws_api_gateway_deployment.proxy_api.stage_name}"
  method_path = "*/*"

  settings {
    logging_level = "${local.log_level}"
  }
}

# IAM
resource "aws_iam_role" "apigw_lambda_execution_role" {
  name = "apigw_lambda_execution_${var.environment}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}


resource "aws_lambda_permission" "integration_lambda_permission" {
  depends_on = ["aws_lambda_function.test_lambda"]
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.test_lambda.arn}"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.proxy_api.execution_arn}/*/*"
}
