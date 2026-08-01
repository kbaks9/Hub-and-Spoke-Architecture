# Global configs
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "nsg_spoke1_name" {
  type = string
}

variable "subnet_spoke1_id" {
  type = string
}

variable "hub_tags" {
  type = map(string)
}

variable "spoke1_tags" {
  type = map(string)
}
