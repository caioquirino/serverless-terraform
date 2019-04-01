output "users_global_table_name" {
  value = "${aws_dynamodb_global_table.users-global.name}"
}
output "users_global_table_arn" {
  value = "${aws_dynamodb_global_table.users-global.arn}"
}
