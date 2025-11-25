########################################
# LEVEL 1 — CORE NETWORKING
########################################

module "vpc" {
  source = "../../modules/vpc"

  env  = var.env
  cidr = "10.0.0.0/16"
}

module "subnets" {
  source = "../../modules/subnets"

  env                  = var.env
  vpc_id               = module.vpc.vpc_id
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
  azs                  = ["us-east-1a", "us-east-1b"]
}

########################################
# LEVEL 1.5 — INTERNET + ROUTING
########################################

module "networking" {
  source = "../../modules/networking"

  env                = var.env
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.subnets.public_subnets
  private_subnet_ids = module.subnets.private_subnets
}

########################################
# LEVEL 2 — SECURITY GROUPS
########################################

module "security_groups" {
  source = "../../modules/security_groups"

  env      = var.env
  vpc_id   = module.vpc.vpc_id
  vpc_cidr = "10.0.0.0/16"
  my_ip    = "198.179.0.21/32"
}

########################################
# LEVEL 2 — EC2 INSTANCE (PRIVATE)
########################################

module "ec2" {
  source = "../../modules/ec2"

  env                = var.env
  ami_id             = "ami-0c02fb55956c7d316"
  instance_type      = "t2.micro"
  subnet_id          = module.subnets.private_subnets[0]
  security_group_ids = [module.security_groups.private_sg_id]
  user_data          = file("${path.module}/userdata.sh")
}

########################################
# LEVEL 3 — APPLICATION LOAD BALANCER
########################################

module "alb" {
  source = "../../modules/alb"

  env                = var.env
  vpc_id             = module.vpc.vpc_id
  public_subnets     = module.subnets.public_subnets
  alb_sg_id          = module.security_groups.public_sg_id
  target_instance_id = module.ec2.instance_id
}


############################################
# S3 BUCKETS
############################################

module "artifacts_bucket" {
  source = "../../modules/S3"

  env           = "dev"
  name          = "artifacts"
  unique_suffix = "alex01"  # <-- CHANGE THIS IF YOU WANT
  expiration_days = 30
}

module "logs_bucket" {
  source = "../../modules/S3"

  env           = "dev"
  name          = "logs"
  unique_suffix = "alex01"  # <-- MUST MATCH ABOVE TO AVOID CONFLICTS
  expiration_days = 30
}




########################################
# LEVEL 4 — BASTION HOST
########################################

module "bastion" {
  source = "../../modules/bastion"

  env              = var.env
  ami_id           = "ami-0c02fb55956c7d316"
  instance_type    = "t2.micro"
  public_subnet_id = module.subnets.public_subnets[0]
  bastion_sg_id    = module.security_groups.bastion_sg_id
  user_data        = file("${path.module}/userdata_bastion.sh")
}
