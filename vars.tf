variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "10.0.0.0/16"
}

variable "subneta_cidr" {
  description = "CIDR block for the subnet a"
  default = "10.0.1.0/24"
}

variable "subnetb_cidr" {
  description = "CIDR block for the subnet a"
  default = "10.0.2.0/24"
}

variable "subneta_az" {
  description = "AZ for subnet A"
  default = "us-east-1a"
}

variable "subnetb_az" {
  description = "AZ for subnet B"
  default = "us-east-1b"
}

variable "cluster_name" {
  description = "ECS Cluster name"
  default = "ecs_cluster"
}