data "aws_ami" "ubuntu" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_id
  availability_zone      = "us-east-1b"    # <--- FORCE FIX (private subnet)
  vpc_security_group_ids = [var.ec2_sg_id]

  tags = {
    Name = "dev-server"
    Env  = var.env
  }
}
