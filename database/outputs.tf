output "connection_string" {
  value     = "postgresql://${aws_db_instance.database.username}:${urlencode(random_string.password.result)}@${aws_db_instance.database.endpoint}/postgres"
  sensitive = true
}

output "instance" {
  value = aws_db_instance.database.id
}
