# Create VPC

# imported via terraform
resource "aws_vpc" "ecs_vpc" {
  # added to prevent recreation (import)
  cidr_block = "192.168.0.0/16"

  # added to prevent recreation (import)
  tags = {
    Name = "interactive-vpc"
  }
}

# imported via terraform  'terraform import aws_security_group.ec2-allow sg-02d42b700dfb9250a'
resource "aws_security_group" "ec2-allow" {
  # added to prevent recreation (import)
  description = "interactive ec2"
}

# imported via terraform  'terraform import aws_subnet.netbox_subnet_a subnet-0d638b14aab6f9db3'
resource "aws_subnet" "netbox_subnet_a" {

  # added to prevent recreation (import)
  vpc_id = aws_vpc.ecs_vpc.id
  cidr_block = "192.168.0.0/24"

  # added to prevent recreation (import)
  tags = {
    Name = "interactive_subneta"
  }
}