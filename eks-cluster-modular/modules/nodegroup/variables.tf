variable "node_sg_id" {
  description = "Security group ID to associate with node group"
  type        = string
}

variable "ssh_key_name" {
  description = "Nom de la clé SSH EC2"
  type        = string
}
