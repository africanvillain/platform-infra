#############################################
# BASTION MODULE
#############################################

data "aws_ami" "amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "bastion" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"
  subnet_id              = var.public_subnet_id
  vpc_security_group_ids = [var.bastion_sg_id]

  associate_public_ip_address = true

  # 💡 IMPORTANT FIX
  lifecycle {
    create_before_destroy = true
  }

  metadata_options {
    http_tokens = "required"
  }

  key_name = var.key_pair_name

  root_block_device {
    volume_size = 10
    volume_type = "gp3"
    delete_on_termination = true
  }

  user_data = file("${path.module}/../../envs/dev/userdata_bastion.sh")

  tags = {
    Name = "${var.env}-bastion"
    Env  = var.env
  }
}
