variable "vpc_id" {
  description = "VPC ID where the EKS cluster is deployed"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}