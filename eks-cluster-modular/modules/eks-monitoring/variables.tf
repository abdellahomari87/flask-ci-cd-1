variable "cluster_name" {
  description = "Name of the EKS cluster"
  type = string
}

variable "cluster_endpoint" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "cluster_certificate_authority_data" {
  type = string
}