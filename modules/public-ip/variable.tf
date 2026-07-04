# Global configs
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "public_ip_name" {
  type = string
}

variable "pip_tags" {
  type = map(string)
}
