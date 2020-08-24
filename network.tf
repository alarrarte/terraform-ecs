# Create VPC

resource "aws_vpc" "ecs_vpc" {
  cidr_block       = var.cidr_vpc
  instance_tenancy = "default"

  tags = {
    Name = "ecs_vpc"
  }
}

# Create Subnets

resource "aws_subnet" "subnet" {
  count = length(var.availability_zones)
  vpc_id     = aws_vpc.ecs_vpc.id
  cidr_block = cidrsubnet(var.cidr_vpc, 8, count.index)
  availability_zone = element(var.availability_zones, count.index)
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


resource "aws_route_table_association" "public" {
  count = length(var.availability_zones)

  subnet_id = element(aws_subnet.subnet.*.id, count.index)
  route_table_id = aws_route_table.rt_public.id
}