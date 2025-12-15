#############################################
# VPC + SUBNETS
#############################################

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.subnets.public_subnets
}

output "private_subnets" {
  value = module.subnets.private_subnets
}

#############################################
# BASTION (FIXED)
#############################################

output "bastion_id" {
  value = module.bastion.instance_id
}

output "bastion_public_ip" {
  value = module.bastion.public_ip
}

#############################################
# EC2 INSTANCES (BLUE / GREEN)
#############################################

output "blue_instance_id" {
  value = module.ec2_blue.instance_id
}

output "blue_private_ip" {
  value = module.ec2_blue.private_ip
}

output "green_instance_id" {
  value = module.ec2_green.instance_id
}

output "green_private_ip" {
  value = module.ec2_green.private_ip
}

#############################################
# ALB
#############################################

output "alb_dns_name" {
  value = module.alb.dns_name
}

output "blue_target_group_arn" {
  value = module.alb.blue_tg_arn
}

output "green_target_group_arn" {
  value = module.alb.green_tg_arn
}

#############################################
# S3 BUCKETS
#############################################

output "artifacts_bucket_name" {
  value = module.artifacts_bucket.bucket_name
}

output "logs_bucket_name" {
  value = module.logs_bucket.bucket_name
}

#############################################
# ECR
#############################################

output "ecr_repo_url" {
  value = module.ecr.repo_url
}
