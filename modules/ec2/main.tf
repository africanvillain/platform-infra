#############################################
# EC2 MODULE (PRIVATE SERVER)
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

#############################################
# IAM ROLE (Do NOT allow replacement)
#############################################

resource "aws_iam_role" "ec2_role" {
  name = "${var.env}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "ecr_readonly" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.env}-ec2-profile"
  role = aws_iam_role.ec2_role.name
}

#############################################
# PRIVATE EC2 SERVER (Blue/Green instance)
#############################################

resource "aws_instance" "server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t3.micro"

  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.ec2_sg_id]

  key_name               = var.key_pair_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name

  associate_public_ip_address = false

  # 💡 IMPORTANT FIX → Avoid “update in-place” errors
  lifecycle {
    create_before_destroy = true
  }

  user_data = templatefile("${path.module}/userdata.tpl", {
    ecr_image_uri = var.ecr_image_uri
  })

  tags = {
    Name = "${var.env}-private-ec2"
    Env  = var.env
  }
}
