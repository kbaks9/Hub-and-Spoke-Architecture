resource "azurerm_resource_group" "rg-grp" {
  name     = var.resource_group
  location = var.location
}

module "network" {
  source              = "./modules/network"
  resource_group_name = azurerm_resource_group.rg-grp.name
  location            = azurerm_resource_group.rg-grp.location

  vnet_hub_name    = var.vnet_hub_name
  spoke1_vnet_name = var.spoke1_vnet_name
  spoke2_vnet_name = var.spoke2_vnet_name

  spoke1_subnet_name              = var.spoke1_subnet_name
  spoke2_subnet_name              = var.spoke2_subnet_name
  application_gateway_subnet_name = var.application_gateway_subnet_name
  bastion_subnet_name             = var.bastion_subnet_name
  firewall_subnet_name            = var.firewall_subnet_name

  hub_tags    = var.hub_tags
  spoke1_tags = var.spoke1_tags
  spoke2_tags = var.spoke2_tags

  hub_address_prefixes                 = var.hub_address_prefixes
  spoke1_address_prefixes              = var.spoke1_address_prefixes
  spoke2_address_prefixes              = var.spoke2_address_prefixes
  application_gateway_address_prefixes = var.application_gateway_address_prefixes
  bastion_address_prefixes             = var.bastion_address_prefixes
  firewall_address_prefixes            = var.firewall_address_prefixes

  hub_address_space    = var.hub_address_space
  spoke1_address_space = var.spoke1_address_space
  spoke2_address_space = var.spoke2_address_space
}

module "nsg" {
  source              = "./modules/nsg"
  resource_group_name = azurerm_resource_group.rg-grp.name
  location            = azurerm_resource_group.rg-grp.location

  nsg_spoke1_name = var.nsg_spoke1_name
  nsg_spoke2_name = var.nsg_spoke2_name

  subnet_spoke1_id = module.network.subnet_spoke1_id
  subnet_spoke2_id = module.network.subnet_spoke2_id

  hub_tags    = var.hub_tags
  spoke1_tags = var.spoke1_tags
  spoke2_tags = var.spoke2_tags
}
