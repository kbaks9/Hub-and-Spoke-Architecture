# Global configs
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "bastion_pip_name" {
  type = string
}

variable "bastion_host_name" {
  type = string
}

variable "bastion_subnet_id" {
  type = string
}

# variable "pip_tags" {
#   type = map(string)
# }
