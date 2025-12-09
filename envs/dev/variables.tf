variable "env" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "key_pair_name" {
  description = "Name of the EC2 key pair"
  type        = string
  default     = "devops_kp"
}
