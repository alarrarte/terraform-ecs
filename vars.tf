variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "10.0.0.0/16"
}


variable "cluster_name" {
  description = "ECS Cluster name"
  default = "ecs_cluster"
}

variable "alb_name" {
  description = "ELB name"
  default = "testalb"
}

variable availability_zones {
  default = [ "us-east-1a", "us-east-1b" ]
}