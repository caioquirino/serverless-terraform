resource "aws_iam_role" "lambda_role" {
  name = "lambda_role_${var.environment}"

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

resource "aws_s3_bucket_object" "deployment" {
  bucket = "${var.lambda_deploy_bucket}"
  key    = "lambda/${var.environment}/serverless-terraform.zip"
  source = "../../serverless-terraform.zip"
  etag = "${md5(file("../../serverless-terraform.zip"))}"

  tags = {
    file_hash = "${md5(file("../../serverless-terraform.zip"))}"
  }
}

resource "aws_lambda_function" "test_lambda" {
  depends_on = ["aws_s3_bucket_object.deployment"]

  s3_bucket        = "${var.lambda_deploy_bucket}"
  s3_key           = "lambda/${var.environment}/serverless-terraform.zip"
  s3_object_version = "${aws_s3_bucket_object.deployment.version_id}"
  //filename       = "../../serverless-terraform.zip"
  function_name    = "serverless_demo_function_${var.environment}"
  role             = "${aws_iam_role.lambda_role.arn}"
  handler          = "src/index.main"
  source_code_hash = "${filebase64sha256("../../serverless-terraform.zip")}"
  runtime          = "nodejs8.10"

  tags = {
    file_hash = "${md5(file("../../serverless-terraform.zip"))}"
  }

  environment {
    variables = {
      LOG_LEVEL = "info"
    }
  }
}

// Logging
# This is to optionally manage the CloudWatch Log Group for the Lambda Function.
# If skipping this resource configuration, also add "logs:CreateLogGroup" to the IAM policy below.
resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${aws_lambda_function.test_lambda.function_name}"
  retention_in_days = 1
}

# See also the following AWS managed policy: AWSLambdaBasicExecutionRole
resource "aws_iam_policy" "lambda_logging" {
  name = "lambda_logging"
  path = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "arn:aws:logs:*:*:*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role = "${aws_iam_role.lambda_role.name}"
  policy_arn = "${aws_iam_policy.lambda_logging.arn}"
}
