variable "env" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "target_instance_id" {
  type = string
}
