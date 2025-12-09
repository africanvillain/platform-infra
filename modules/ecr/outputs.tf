#############################################
# ECR OUTPUTS
#############################################

output "repo_url" {
  value = aws_ecr_repository.this.repository_url
}

output "repository_arn" {
  value = aws_ecr_repository.this.arn
}
