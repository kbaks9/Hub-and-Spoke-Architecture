# Hub VNet & associated subnets
resource "azurerm_virtual_network" "hub_vnet" {
  name                = var.vnet_hub_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.hub_address_space
  tags                = var.hub_tags
}

resource "azurerm_subnet" "firewall_subnet" {
  name                 = var.firewall_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = var.firewall_address_prefixes
}

resource "azurerm_subnet" "bastion_subnet" {
  name                 = var.bastion_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = var.bastion_address_prefixes
}

resource "azurerm_subnet" "application_gateway_subnet" {
  name                 = var.application_gateway_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.hub_vnet.name
  address_prefixes     = var.application_gateway_address_prefixes
}

# Spoke 1 VNet & Subnet
resource "azurerm_virtual_network" "spoke1_vnet" {
  name                = var.spoke1_vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.spoke1_address_space
  tags                = var.spoke1_tags
}

resource "azurerm_subnet" "spoke1_subnet" {
  name                 = var.spoke1_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.spoke1_vnet.name
  address_prefixes     = var.spoke1_address_prefixes
}

# VNet Peering #
resource "azurerm_virtual_network_peering" "hub_spoke1_peer" {
  name                      = var.hub_spoke1_peer_name
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.hub_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.spoke1_vnet.id
  allow_forwarded_traffic   = true
}


resource "azurerm_virtual_network_peering" "spoke1_hub_peer" {
  name                      = var.spoke1_hub_peer_name
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.spoke1_vnet.name
  remote_virtual_network_id = azurerm_virtual_network.hub_vnet.id
  allow_forwarded_traffic   = true
}
