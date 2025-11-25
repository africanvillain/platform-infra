###############################
# APPLICATION LOAD BALANCER
###############################

resource "aws_lb" "this" {
  name               = "${var.env}-alb"
  load_balancer_type = "application"
  internal           = false

  security_groups = [var.alb_sg_id]
  subnets         = var.public_subnets

  tags = {
    Name = "${var.env}-alb"
    Env  = var.env
  }
}

###############################
# TARGET GROUP
###############################

resource "aws_lb_target_group" "this" {
  name     = "${var.env}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name = "${var.env}-tg"
    Env  = var.env
  }
}

###############################
# ATTACH EC2 TO TARGET GROUP
###############################

resource "aws_lb_target_group_attachment" "instance" {
  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.target_instance_id
  port             = 80
}

###############################
# LISTENER
###############################

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}
