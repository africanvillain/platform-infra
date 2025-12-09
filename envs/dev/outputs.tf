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
# EC2 INSTANCES
#############################################

output "blue_instance_id" {
  value = module.ec2_blue.instance_id
}

output "green_instance_id" {
  value = module.ec2_green.instance_id
}

#############################################
# ALB
#############################################

output "alb_dns_name" {
  value = module.alb.dns_name
}

#############################################
# S3
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
