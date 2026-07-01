# Global configs
variable "resource_group" {
  type = string
}

variable "location" {
  type = string
}

# Networking
variable "vnet_hub_name" {
  type = string
}

variable "spoke1_vnet_name" {
  type = string
}

variable "spoke2_vnet_name" {
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

variable "application_gateway_address_prefixes" {
  type = list(string)
}

variable "bastion_address_prefixes" {
  type = list(string)
}

variable "firewall_address_prefixes" {
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

variable "application_gateway_subnet_name" {
  type = string
}

variable "bastion_subnet_name" {
  type = string
}

variable "firewall_subnet_name" {
  type = string
}

# NSG Module
variable "nsg_spoke1_name" {
  type = string
}

variable "nsg_spoke2_name" {
  type = string
}

variable "nsg_application_gateway_name" {
  type = string
}

variable "nsg_bastion_name" {
  type = string
}

variable "nsg_firewall_name" {
  type = string
}

