# Global configs
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vm_subnet_id" {
  type = string
}

variable "ssh_public_key" {
  description = "SSH public key used to access the VMSS instances"
  type        = string
  sensitive   = true
}
