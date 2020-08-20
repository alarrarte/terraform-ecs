variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default = "10.0.0.0/16"
}

variable "subneta_cidr" {
  description = "CIDR block for the subnet a"
  default = "10.0.1.0/24"
}

variable "cluster_name" {
  description = "ECS Cluster name"
  default = "ecs_cluster"
}