# Global configs
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "rt_name" {
  type = string
}

variable "rt_rule_name" {
  type = string
}

variable "next_hop_in_ip_address" {
  type = string
}

variable "rt_spoke1_subnet_id" {
  type = string
}

variable "rt_spoke2_subnet_id" {
  type = string
}

variable "rt_tags" {
  type = map(string)
}

