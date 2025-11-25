output "instance_id" {
  value = aws_instance.server.id
}

output "private_ip" {
  value = aws_instance.server.private_ip
}
