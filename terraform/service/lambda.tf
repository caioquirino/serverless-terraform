resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = <<EOF
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
EOF
}

resource "aws_lambda_function" "test_lambda" {
  filename         = "../../serverless-terraform.zip"
  function_name    = "serverless_demo_function"
  role             = "${aws_iam_role.lambda_role.arn}"
  handler          = "src/index.main"
  source_code_hash = "${filebase64sha256("../../serverless-terraform.zip")}"
  runtime          = "nodejs8.10"

  environment {
    variables = {
    }
  }
}
