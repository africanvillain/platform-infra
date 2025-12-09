#############################################
# ALB OUTPUTS
#############################################

# Load Balancer ARN
output "alb_arn" {
  value = aws_lb.this.arn
}

# Load Balancer DNS Name (This is what you need!)
output "dns_name" {
  value = aws_lb.this.dns_name
}

# Blue Target Group ARN
output "blue_tg_arn" {
  value = aws_lb_target_group.blue.arn
}

# Green Target Group ARN
output "green_tg_arn" {
  value = aws_lb_target_group.green.arn
}
