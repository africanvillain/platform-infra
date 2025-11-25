variable "env" {
  type = string
}

variable "name" {
  type = string
}

variable "unique_suffix" {
  type = string
  description = "Globally-unique suffix to avoid S3 bucket name conflicts"
}

variable "expiration_days" {
  type        = number
  description = "Lifecycle expiration days"
  default     = 30
}
