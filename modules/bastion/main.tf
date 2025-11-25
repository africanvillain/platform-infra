resource "aws_instance" "bastion" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.public_subnet_id
  vpc_security_group_ids      = [var.bastion_sg_id]
  associate_public_ip_address = true

  user_data = var.user_data

  tags = {
    Name = "${var.env}-bastion"
    Env  = var.env
  }
}
