variable "env" {}

variable "ami_id" {}

variable "instance_type" {
  default = "t2.micro"
}

variable "subnet_id" {}

variable "security_group_ids" {
  type = list(string)
}

variable "user_data" {
  default = ""
}
