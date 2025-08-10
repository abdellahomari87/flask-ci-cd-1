variable "region" {
  default = "us-east-1"
}

variable "ssh_key_name" {
  description = "Nom de la clé SSH EC2"
  type        = string
}
