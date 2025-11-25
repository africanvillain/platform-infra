data "aws_ami" "amazon_linux_2" {
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

resource "aws_instance" "server" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t3.micro"
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.ec2_sg_id]

  # if you don't want userdata, you can comment this out
  user_data = file("${path.module}/../../envs/dev/userdata.sh")

  tags = {
    Name = "${var.env}-app-server"
    Env  = var.env
  }
}
