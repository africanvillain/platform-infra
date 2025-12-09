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

variable "blue_target_id" {
  type = string
}

variable "green_target_id" {
  type = string
}

variable "blue_weight" {
  type    = number
  default = 100
}

variable "green_weight" {
  type    = number
  default = 0
}
