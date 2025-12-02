#############################################
# ALB BLUE/GREEN MODULE
#############################################

resource "aws_lb" "this" {
  name               = "${var.env}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [var.alb_sg_id]
  subnets         = var.public_subnets

  tags = {
    Name = "${var.env}-alb"
    Env  = var.env
  }
}

#############################################
# TARGET GROUPS (BLUE + GREEN)
#############################################

resource "aws_lb_target_group" "blue" {
  name     = "${var.env}-tg-blue"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name = "${var.env}-tg-blue"
    Env  = var.env
    Role = "blue"
  }
}

resource "aws_lb_target_group" "green" {
  name     = "${var.env}-tg-green"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name = "${var.env}-tg-green"
    Env  = var.env
    Role = "green"
  }
}

#############################################
# ATTACH SINGLE EC2 INSTANCE TO BOTH TGs
#############################################

resource "aws_lb_target_group_attachment" "blue_attachment" {
  target_group_arn = aws_lb_target_group.blue.arn
  target_id        = var.target_instance_id
  port             = 80
}

resource "aws_lb_target_group_attachment" "green_attachment" {
  target_group_arn = aws_lb_target_group.green.arn
  target_id        = var.target_instance_id
  port             = 80
}

#############################################
# LISTENER — CHOOSES ACTIVE COLOR
#############################################

locals {
  active_tg_arn = var.active_color == "green" ? aws_lb_target_group.green.arn : aws_lb_target_group.blue.arn
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = local.active_tg_arn
  }
}
