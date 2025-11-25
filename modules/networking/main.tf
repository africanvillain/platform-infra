###############################
# INTERNET GATEWAY
###############################

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-igw"
    Env  = var.env
  }
}

###############################
# NAT GATEWAY (IN FIRST PUBLIC SUBNET)
###############################

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name = "${var.env}-nat-eip"
    Env  = var.env
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = var.public_subnet_ids[0]

  tags = {
    Name = "${var.env}-nat-gw"
    Env  = var.env
  }

  depends_on = [aws_internet_gateway.igw]
}

###############################
# PUBLIC ROUTE TABLE
###############################

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-public-rt"
    Env  = var.env
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_subnets" {
  count          = length(var.public_subnet_ids)
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}

###############################
# PRIVATE ROUTE TABLE
###############################

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.env}-private-rt"
    Env  = var.env
  }
}

resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_subnets" {
  count          = length(var.private_subnet_ids)
  subnet_id      = var.private_subnet_ids[count.index]
  route_table_id = aws_route_table.private.id
}
