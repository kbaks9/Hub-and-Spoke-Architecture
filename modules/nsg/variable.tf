# Global configs
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

# Security Rules Configs
# variable "nsg_direction" { # Inbound or Outbound
#   type = string
# }

# Network Security Group Names
variable "nsg_spoke1_name" {
  type = string
}

variable "nsg_spoke2_name" {
  type = string
}

variable "nsg_monitor_name" {
  type = string
}

# Security Rule Names

# Tags
variable "hub_tags" {
  type = map(string)
}

variable "spoke1_tags" {
  type = map(string)
}

variable "spoke2_tags" {
  type = map(string)
}
