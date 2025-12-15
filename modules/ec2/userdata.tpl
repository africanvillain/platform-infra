#!/bin/bash
set -e

# ==============================
# BASIC SETUP
# ==============================

yum update -y

# ==============================
# DOCKER MODE (ECR IMAGE PROVIDED)
# ==============================

if [ ! -z "${ecr_image_uri}" ]; then
  echo "Docker image detected. Enabling container mode..."

  # Install Docker
  amazon-linux-extras install docker -y
  systemctl enable docker
  systemctl start docker
  usermod -aG docker ec2-user

  # Install AWS CLI
  yum install -y awscli

  # Extract ECR registry
  ECR_REGISTRY=$(echo ${ecr_image_uri} | cut -d'/' -f1)

  echo "Logging into ECR: $ECR_REGISTRY"

  aws ecr get-login-password --region us-east-1 \
    | docker login --username AWS --password-stdin $ECR_REGISTRY

  # Pull image
  docker pull ${ecr_image_uri}

  # Stop/remove old container if exists
  docker stop app || true
  docker rm app || true

  # ==============================
  # RUN CONTAINER WITH BLUE/GREEN METADATA
  # ==============================

  docker run -d \
    --name app \
    -p 80:80 \
    -e APP_COLOR="${deploy_color}" \
    -e APP_STATUS="${deploy_status}" \
    -e APP_VERSION="${app_version}" \
    ${ecr_image_uri}

else
  echo "No Docker image passed. Running fallback EC2 mode."

  yum install -y httpd
  systemctl enable httpd
  systemctl start httpd

  echo "<h1>EC2 running without Docker</h1>" > /var/www/html/index.html
fi
