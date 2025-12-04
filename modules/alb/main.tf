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
# BLUE TARGET GROUP
#############################################

resource "aws_lb_target_group" "blue" {
  name        = "${var.env}-tg-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.env}-tg-blue"
    Env  = var.env
  }
}

resource "aws_lb_target_group_attachment" "blue" {
  target_group_arn = aws_lb_target_group.blue.arn
  target_id        = var.blue_target_id
  port             = 80
}

#############################################
# GREEN TARGET GROUP
#############################################

resource "aws_lb_target_group" "green" {
  name        = "${var.env}-tg-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.env}-tg-green"
    Env  = var.env
  }
}

resource "aws_lb_target_group_attachment" "green" {
  target_group_arn = aws_lb_target_group.green.arn
  target_id        = var.green_target_id
  port             = 80
}

#############################################
# LISTENER — CHOOSES ACTIVE COLOR
#############################################

locals {
  active_tg_arn = (
    var.active_color == "green"
    ? aws_lb_target_group.green.arn
    : aws_lb_target_group.blue.arn
  )
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
