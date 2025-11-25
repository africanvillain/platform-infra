variable "env" {}

variable "ami_id" {}
variable "instance_type" {
  default = "t2.micro"
}

variable "public_subnet_id" {}
variable "bastion_sg_id" {}

variable "user_data" {
  default = ""
}
