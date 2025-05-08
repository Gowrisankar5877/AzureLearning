variable "location" {
  default = "East US"
}

variable "ssh_public_key" {
  description = "Path to your public SSH key"
  default     = "~/.ssh/id_rsa.pub"
}
