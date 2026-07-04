# Global configs
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "firewall_name" {
  type = string
}

variable "firewall_subnet_id" {
  type = string
}

variable "firewall_public_ip_address_id" {
  type = string
}

variable "firewall_tags" {
  type = map(string)
}
