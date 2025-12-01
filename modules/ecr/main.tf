#############################################
# ECR REPOSITORY
#############################################

resource "aws_ecr_repository" "this" {
  name = "${var.env}-${var.name}"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name = "${var.env}-${var.name}"
    Env  = var.env
  }
}
