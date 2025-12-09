#!/bin/bash

# Update packages
yum update -y

# If an ECR image URI is provided, enable Docker deployment mode
if [ ! -z "${ecr_image_uri}" ]; then

  echo "Docker image detected. Enabling container mode..."

  # Install Docker
  amazon-linux-extras install docker -y
  systemctl enable docker
  systemctl start docker

  # Add ec2-user to docker group
  usermod -aG docker ec2-user

  # Install AWS CLI (for ECR pull)
  yum install -y awscli

  # Pull latest image from ECR
  docker pull ${ecr_image_uri}

  # Stop & remove old container (if exists)
  docker stop app || true
  docker rm app || true

  # Run container
  docker run -d --name app -p 80:80 ${ecr_image_uri}

else
  echo "No Docker image passed. Running in NORMAL EC2 MODE."

  # Example of standard EC2 setup (you can customize this later)
  yum install -y httpd
  systemctl enable httpd
  systemctl start httpd

  echo "<h1>${ecr_image_uri} - EC2 server running without Docker</h1>" > /var/www/html/index.html

fi
