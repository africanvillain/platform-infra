###########################################
# VPC
###########################################

module "vpc" {
  source = "../../modules/vpc"

  env  = "dev"
  cidr = "10.0.0.0/16"
}

###########################################
# SUBNETS (FORCED AZ FIX)
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
# PRIVATE EC2 INSTANCE
###########################################

module "ec2" {
  source = "../../modules/ec2"

  env               = "dev"
  private_subnet_id = module.subnets.private_subnets[0]
  ec2_sg_id         = module.security_groups.private_sg_id
}

###########################################
# BASTION HOST (PUBLIC)
###########################################

module "bastion" {
  source = "../../modules/bastion"

  env              = "dev"
  public_subnet_id = module.subnets.public_subnets[0]
  bastion_sg_id    = module.security_groups.bastion_sg_id
}

###########################################
# APPLICATION LOAD BALANCER
###########################################

module "alb" {
  source = "../../modules/alb"

  env                = "dev"
  vpc_id             = module.vpc.vpc_id
  alb_sg_id          = module.security_groups.public_sg_id
  public_subnets     = module.subnets.public_subnets
  target_instance_id = module.ec2.instance_id
}

###########################################
# S3 BUCKETS (Artifacts + Logs)
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
