data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"] # Canonical Ubuntu

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*"]
  }
}

resource "aws_instance" "server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.ec2_sg_id]

  # ❌ REMOVE availability_zone entirely
  # availability_zone = "us-east-1e"

  tags = {
    Name = "dev-server"
    Env  = var.env
  }
}
