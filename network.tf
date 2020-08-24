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
  route_table_id  = aws_route_table.rt_public.id
  
}






# SG 

resource "aws_security_group" "alb" {
  name   = "sg-alb"
  vpc_id = aws_vpc.ecs_vpc.id
 
  ingress {
   protocol         = "tcp"
   from_port        = 80
   to_port          = 80
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
 
  ingress {
   protocol         = "tcp"
   from_port        = 443
   to_port          = 443
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
 
  egress {
   protocol         = "-1"
   from_port        = 0
   to_port          = 0
   cidr_blocks      = ["0.0.0.0/0"]
   ipv6_cidr_blocks = ["::/0"]
  }
}