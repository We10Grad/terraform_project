# Building a VPC with public and private subnets, NAT Gateway, and necessary routing

resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "project_public_1"    {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

  resource "aws_subnet" "project_public_2"    {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "project_public_3"    {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_3_cidr
  availability_zone = "us-east-1c"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "project_private_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_1_cidr
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "project_private_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = "us-east-1b"
}

resource "aws_route_table" "project_public_1" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.public_subnet_1_cidr
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table" "project_public_2" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.public_subnet_2_cidr
    gateway_id = aws_internet_gateway.main.id
  }
}
