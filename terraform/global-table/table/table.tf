variable environment {}

resource "aws_dynamodb_table" "users-table" {

  hash_key = "user_id"
  name = "${var.environment}_users"
  stream_enabled = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "user_id"
    type = "S"
  }
}
