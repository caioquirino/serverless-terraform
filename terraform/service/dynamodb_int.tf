data "terraform_remote_state" "global-table" {
  backend = "s3"

  config {
    region = "us-east-1"
    bucket = "${var.profile}-tfstate"
    key = "services/serverless-terraform/${var.environment}/global/serverless-terraform-global-table.tfstate"
    profile = "${var.profile}"
  }
}



data "aws_iam_policy_document" "dynamodb_access_policy_document" {
  statement {
    actions = [
      "dynamodb:Scan"
    ]

    effect = "Allow"
    resources = [
      "arn:aws:dynamodb:${var.region}:${var.profile}:table/${data.terraform_remote_state.global-table.users_global_table_name}",
    ]
  }
}

resource "aws_iam_policy" "dynamodb_access_policy" {
  name = "${var.region}-dynamodb-access-policy"
  policy = "${data.aws_iam_policy_document.dynamodb_access_policy_document.json}"
}


resource "aws_iam_role_policy_attachment" "dynamodb_access_policy_attachment" {
  role = "${aws_iam_role.lambda_role.name}"
  policy_arn = "${aws_iam_policy.dynamodb_access_policy.arn}"
  depends_on = [
    "aws_iam_role.lambda_role"
  ]
}
