# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/24"
  tags = {
    Name = "main"
  }
}

# Public Subnet
resource "aws_subnet" "public-main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.cidr_block_public
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone
  tags = {
    Name = "main-public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private-main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.cidr_block_private
  availability_zone = var.availability_zone
  tags = {
    Name = "main-private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main-igw"
  }
}

# Public Route Table
resource "aws_route_table" "public-routes" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "main-public-route"
  }
}

# Private Route Table (using NAT)
resource "aws_route_table" "private-routes" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "main-private-route"
  }
}

# Public Subnet Association
resource "aws_route_table_association" "public-association" {
  subnet_id      = aws_subnet.public-main.id
  route_table_id = aws_route_table.public-routes.id
}

# Private Subnet Association
resource "aws_route_table_association" "private-association" {
  subnet_id      = aws_subnet.private-main.id
  route_table_id = aws_route_table.private-routes.id
}

# Elastic IP for NAT
resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = {
    Name = "nat-eip"
  }
}

# NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public-main.id
  tags = {
    Name = "main-nat-gateway"
  }
  depends_on = [aws_internet_gateway.igw]
}

