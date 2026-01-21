# Building a VPC with public and private subnets, NAT Gateway, and necessary routing

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "public_subnet_1"    {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

  resource "aws_subnet" "public_subnet_2"    {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_3"    {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_3_cidr
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "us-east-1b"
}

# Create public route tables and routes
resource "aws_route_table" "public_route_1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Project_IGW.id
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "Project_NAT" {
  allocation_id = aws_eip.Project_NAT_EIP.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags = {
    Name = "Project NAT"
  }
   # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.Project_IGW]
}

# Create Elastic IP for NAT Gateway
resource "aws_eip" "Project_NAT_EIP" {
  domain = "vpc"
}


# Create private route tables and routes
resource "aws_route_table" "private_route_1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.Project_NAT.id
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "Project_IGW" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Project IGW"
  }
}

# Create Route table associations
resource "aws_route_table_association" "pub_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_route_1.id
}

resource "aws_route_table_association" "pub_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_route_1.id
}

resource "aws_route_table_association" "pub_assoc_3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public_route_1.id
}

resource "aws_route_table_association" "priv_assoc_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_1.id
}

resource "aws_route_table_association" "priv_assoc_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_1.id
  }

# Security Groups