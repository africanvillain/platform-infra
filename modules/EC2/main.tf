resource "aws_instance" "server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = false

  user_data = var.user_data

  tags = {
    Name = "${var.env}-ec2"
    Env  = var.env
  }
}
