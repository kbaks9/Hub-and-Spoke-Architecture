# Global configs
variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "vnet_hub_name" {
  type = string
}

variable "spoke1_vnet_name" {
  type = string
}

variable "spoke2_vnet_name" {
  type = string
}

variable "hub_subnet_name" {
  type = string
}

variable "spoke1_subnet_name" {
  type = string
}

variable "spoke2_subnet_name" {
  type = string
}

variable "hub_address_space" {
  type = list(string)
}

variable "spoke1_address_space" {
  type = list(string)
}

variable "spoke2_address_space" {
  type = list(string)
}

variable "hub_address_prefixes" {
  type = list(string)
}

variable "spoke1_address_prefixes" {
  type = list(string)
}

variable "spoke2_address_prefixes" {
  type = list(string)
}

variable "gateway_address_prefixes" {
  type = list(string)
}

variable "bastion_address_prefixes" {
  type = list(string)
}

variable "firewall_address_prefixes" {
  type = list(string)
}

variable "monitor_address_prefixes" {
  type = list(string)
}

variable "hub_tags" {
  type = map(string)
}

variable "spoke1_tags" {
  type = map(string)
}

variable "spoke2_tags" {
  type = map(string)
}

variable "gateway_subnet_name" {
  type = string
}

variable "bastion_subnet_name" {
  type = string
}

variable "firewall_subnet_name" {
  type = string
}

variable "monitor_subnet_name" {
  type = string
}
