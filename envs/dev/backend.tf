terraform {
  backend "s3" {
    bucket = "alex-tf-state-us-east-1" # <-- your bucket
    key    = "dev/terraform.tfstate"
    region = "us-east-1"
  }
}
