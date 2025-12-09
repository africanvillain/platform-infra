#############################################
# EC2 MODULE VARIABLES
#############################################

variable "env" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "ec2_sg_id" {
  type = string
}

# SSH key pair for manual access
variable "key_pair_name" {
  type = string
}

# OPTIONAL Docker image URI (used later when deploying containers)
variable "ecr_image_uri" {
  type    = string
  default = ""
}
