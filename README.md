# Platform Infrastructure (AWS + Terraform)

## Overview
This project demonstrates production-style AWS infrastructure built using Terraform,
including networking, security, load balancing, and blue/green deployment patterns.

## Architecture
- Custom VPC with public and private subnets
- Internet Gateway and NAT Gateway
- Bastion host for secure access to private instances
- Application Load Balancer with blue/green target groups
- Modular Terraform code structure

## Technologies Used
- AWS (EC2, VPC, ALB, IAM, S3, ECR)
- Terraform
- Linux

## Deployment Flow
1. Terraform initializes and provisions core networking
2. EC2 instances are deployed in private subnets
3. ALB routes traffic using blue/green target groups
4. Bastion host provides controlled administrative access

## Key Learnings
- Designing secure AWS networking
- Managing infrastructure with Terraform modules
- Implementing blue/green infrastructure patterns
- Controlling cloud costs and safe teardown
