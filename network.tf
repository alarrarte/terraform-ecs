# Create VPC

resource "aws_vpc" "ecs_vpc" {
  cidr_block       = var.cidr_vpc
  instance_tenancy = "default"

  tags = {
    Name = "ecs_vpc"
  }
}

# Create Subnets

resource "aws_subnet" "subnet_a" {
  vpc_id     = aws_vpc.ecs_vpc.id
  cidr_block = var.subneta_cidr
  availability_zone = var.subneta_az
  map_public_ip_on_launch = true
}

resource "aws_subnet" "subnet_b" {
  vpc_id     = aws_vpc.ecs_vpc.id
  cidr_block = var.subnetb_cidr
  availability_zone = var.subnetb_az
  map_public_ip_on_launch = true
}

# Create Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.ecs_vpc.id

}


# Create Route Table

resource "aws_route_table" "rt_public" {
  vpc_id = aws_vpc.ecs_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}


# Associate rt with subnet 

resource "aws_route_table_association" "rta_a" {
  subnet_id      = aws_subnet.subnet_a.id
  route_table_id = aws_route_table.rt_public.id
}

resource "aws_route_table_association" "rta_b" {
  subnet_id      = aws_subnet.subnet_b.id
  route_table_id = aws_route_table.rt_public.id
}