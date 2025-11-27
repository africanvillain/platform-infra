###########################################
# VPC
###########################################
output "vpc_id" {
  value = module.vpc.vpc_id
}

###########################################
# SUBNETS
###########################################
output "public_subnets" {
  value = module.subnets.public_subnets
}

output "private_subnets" {
  value = module.subnets.private_subnets
}

###########################################
# BASTION HOST
###########################################
output "bastion_public_ip" {
  value = module.bastion.bastion_public_ip
}

output "bastion_id" {
  value = module.bastion.bastion_id
}

###########################################
# EC2 APP INSTANCE
###########################################
output "ec2_instance_id" {
  value = module.ec2.instance_id
}

output "ec2_private_ip" {
  value = module.ec2.private_ip
}

###########################################
# ALB
###########################################
output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

###########################################
# S3 BUCKETS
###########################################
output "artifacts_bucket" {
  value = module.artifacts_bucket.bucket_id
}

output "logs_bucket" {
  value = module.logs_bucket.bucket_id
}
