###########################################
# VPC
###########################################

module "vpc" {
  source = "../../modules/vpc"

  env  = "dev"
  cidr = "10.0.0.0/16"
}

###########################################
# SUBNETS
###########################################

module "subnets" {
  source = "../../modules/subnets"

  env                  = "dev"
  vpc_id               = module.vpc.vpc_id
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
}

###########################################
# NETWORKING (IGW, NAT, Routes)
###########################################

module "networking" {
  source = "../../modules/networking"

  env                = "dev"
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.subnets.public_subnets
  private_subnet_ids = module.subnets.private_subnets
}

###########################################
# SECURITY GROUPS
###########################################

module "security_groups" {
  source = "../../modules/security_groups"

  env    = "dev"
  vpc_id = module.vpc.vpc_id
}

###########################################
# EC2 BLUE
###########################################

module "ec2_blue" {
  source = "../../modules/ec2"

  env               = "dev-blue"
  private_subnet_id = module.subnets.private_subnets[0]
  ec2_sg_id         = module.security_groups.private_sg_id
  key_pair_name     = "devops_kp"
  ecr_image_uri = "144520190518.dkr.ecr.us-east-1.amazonaws.com/dev-app:1765327817"

}

###########################################
# EC2 GREEN
###########################################

module "ec2_green" {
  source = "../../modules/ec2"

  env               = "dev-green"
  private_subnet_id = module.subnets.private_subnets[1]
  ec2_sg_id         = module.security_groups.private_sg_id
  key_pair_name     = "devops_kp"
  ecr_image_uri = "144520190518.dkr.ecr.us-east-1.amazonaws.com/dev-app:1765327817"

}

###########################################
# BASTION
###########################################

module "bastion" {
  source = "../../modules/bastion"

  env              = "dev"
  public_subnet_id = module.subnets.public_subnets[0]
  bastion_sg_id    = module.security_groups.bastion_sg_id
  key_pair_name    = "devops_kp"
}

###########################################
# APPLICATION LOAD BALANCER (BLUE/GREEN)
###########################################

module "alb" {
  source = "../../modules/alb"

  env            = "dev"
  vpc_id         = module.vpc.vpc_id
  alb_sg_id      = module.security_groups.public_sg_id
  public_subnets = module.subnets.public_subnets

  # BLUE/GREEN TARGETS
  blue_target_id  = module.ec2_blue.instance_id
  green_target_id = module.ec2_green.instance_id

  # Canary rollout weights
  blue_weight  = 90
  green_weight = 10
}

###########################################
# S3 BUCKETS
###########################################

module "artifacts_bucket" {
  source = "../../modules/S3"

  env             = "dev"
  name            = "artifacts"
  unique_suffix   = "alex01"
  expiration_days = 30
}

module "logs_bucket" {
  source = "../../modules/S3"

  env             = "dev"
  name            = "logs"
  unique_suffix   = "alex01"
  expiration_days = 30
}

###########################################
# ECR
###########################################

module "ecr" {
  source = "../../modules/ecr"

  env  = "dev"
  name = "app"
}
