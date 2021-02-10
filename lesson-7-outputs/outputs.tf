output "webserver_instance_id" {
  value = aws_instance.my_webserver.id
  description = "This is description"
}

output "webserver_instance_public_ip" {
  value = aws_eip.my_static_ip.public_ip
}

output "webserver_sq_id" {
  value = aws_security_group.my_webserver.id
}

output "webserver_sq_arn" {
  value = aws_security_group.my_webserver.arn
}