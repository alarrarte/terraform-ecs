# VPC
variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "10.0.0.0/16"
}

variable availability_zones {
  default = [ "us-east-1a", "us-east-1b" ]
}

# EC2
variable "alb_name" {
  description = "ELB name"
  default = "testalb"
}
# test commit on branch
# Launch configuration
variable "lc_ami" {
  default = "ami-fad25980"
}
variable "lc_flavor" {
  default = "t2.micro"
}

variable "ecs_key_pair_name" {
  default = "interactive"
}

# ASG
variable "max_instance_size" {
  default = "3"
}

variable "min_instance_size" {
  default = "1"
}

variable "desired_capacity" {
  default = "2"
}

# ECS
variable "cluster_name" {
  description = "ECS Cluster name"
  default = "ecs_cluster"
}

