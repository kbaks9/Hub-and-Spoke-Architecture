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

variable "spoke1_subnet_name" {
  type = string
}

variable "hub_address_space" {
  type = list(string)
}

variable "spoke1_address_space" {
  type = list(string)
}

variable "hub_address_prefixes" {
  type = list(string)
}

variable "spoke1_address_prefixes" {
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

variable "application_gateway_subnet_name" {
  type = string
}

variable "bastion_subnet_name" {
  type = string
}

variable "firewall_subnet_name" {
  type = string
}

variable "hub_spoke1_peer_name" {
  type = string
}

variable "spoke1_hub_peer_name" {
  type = string
}

# End of Network Module #

# NSG Module
variable "nsg_spoke1_name" {
  type = string
}

### Public-IP
variable "public_ip_name" {
  type = string
}

variable "pip_tags" {
  type = map(string)
}

### Firewall
variable "firewall_name" {
  type = string
}

variable "firewall_policy_name" {
  type = string
}

variable "firewall_tags" {
  type = map(string)
}

### Route Table
variable "rt_name" {
  type = string
}

variable "rt_rule_name" {
  type = string
}

variable "rt_tags" {
  type = map(string)
}

# Bastion
variable "bastion_pip_name" {
  type = string
}

variable "bastion_host_name" {
  type = string
}

# Storage
variable "storage_account_name" {
  type = string
}

variable "storage_tags" {
  type = map(string)
}

# Monitor
variable "log_analytics_name" {
  type = string
}
