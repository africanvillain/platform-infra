#############################################
# SUBNETS MODULE
#############################################

variable "env" {}
variable "vpc_id" {}
variable "public_subnet_cidrs" { type = list(string) }
variable "private_subnet_cidrs" { type = list(string) }

# Ask AWS for all AZs your account supports
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  # Use the first N AZs your account supports
  azs = slice(data.aws_availability_zones.available.names, 0, length(var.public_subnet_cidrs))
}

#############################################
# PUBLIC SUBNETS
#############################################

resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.env}-public-${count.index}"
    Env  = var.env
  }
}

#############################################
# PRIVATE SUBNETS
#############################################

resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = local.azs[count.index]

  tags = {
    Name = "${var.env}-private-${count.index}"
    Env  = var.env
  }
}

#############################################
# OUTPUTS
#############################################

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_subnets" {
  value = aws_subnet.private[*].id
}
