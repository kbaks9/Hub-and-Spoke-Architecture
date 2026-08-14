resource "azurerm_resource_group" "rg-grp" {
  name     = var.resource_group
  location = var.location
}

module "network" {
  source                               = "./modules/network"
  resource_group_name                  = azurerm_resource_group.rg-grp.name
  location                             = azurerm_resource_group.rg-grp.location
  vnet_hub_name                        = var.vnet_hub_name
  spoke1_vnet_name                     = var.spoke1_vnet_name
  spoke1_subnet_name                   = var.spoke1_subnet_name
  application_gateway_subnet_name      = var.application_gateway_subnet_name
  bastion_subnet_name                  = var.bastion_subnet_name
  firewall_subnet_name                 = var.firewall_subnet_name
  hub_spoke1_peer_name                 = var.hub_spoke1_peer_name
  spoke1_hub_peer_name                 = var.spoke1_hub_peer_name
  hub_tags                             = var.hub_tags
  spoke1_tags                          = var.spoke1_tags
  hub_address_prefixes                 = var.hub_address_prefixes
  spoke1_address_prefixes              = var.spoke1_address_prefixes
  application_gateway_address_prefixes = var.application_gateway_address_prefixes
  bastion_address_prefixes             = var.bastion_address_prefixes
  firewall_address_prefixes            = var.firewall_address_prefixes
  hub_address_space                    = var.hub_address_space
  spoke1_address_space                 = var.spoke1_address_space
}

module "nsg" {
  source              = "./modules/nsg"
  resource_group_name = azurerm_resource_group.rg-grp.name
  location            = azurerm_resource_group.rg-grp.location
  nsg_spoke1_name     = var.nsg_spoke1_name
  subnet_spoke1_id    = module.network.subnet_spoke1_id
  hub_tags            = var.hub_tags
  spoke1_tags         = var.spoke1_tags
}

module "compute" {
  source              = "./modules/compute"
  resource_group_name = azurerm_resource_group.rg-grp.name
  location            = azurerm_resource_group.rg-grp.location
  vm_subnet_id        = module.network.subnet_spoke1_id
  depends_on = [
    module.firewall,
    module.route_tables,
    module.nsg
  ]
}

module "public-ip" {
  source              = "./modules/public-ip"
  resource_group_name = azurerm_resource_group.rg-grp.name
  location            = azurerm_resource_group.rg-grp.location
  public_ip_name      = var.public_ip_name
  pip_tags            = var.pip_tags
}

module "bastion" {
  source              = "./modules/bastion"
  resource_group_name = azurerm_resource_group.rg-grp.name
  location            = azurerm_resource_group.rg-grp.location
  bastion_pip_name    = var.bastion_pip_name
  bastion_host_name   = var.bastion_host_name
  bastion_subnet_id   = module.network.subnet_bastion_id
  # Still need to add pip tags
}

module "firewall" {
  source                        = "./modules/firewall"
  resource_group_name           = azurerm_resource_group.rg-grp.name
  location                      = azurerm_resource_group.rg-grp.location
  firewall_name                 = var.firewall_name
  firewall_subnet_id            = module.network.subnet_firewall_id
  firewall_public_ip_address_id = module.public-ip.public_ip_address_id
  firewall_tags                 = var.firewall_tags
  firewall_policy_name          = var.firewall_policy_name
  #PR test pull
}

module "route_tables" {
  source                 = "./modules/route_tables"
  resource_group_name    = azurerm_resource_group.rg-grp.name
  location               = azurerm_resource_group.rg-grp.location
  rt_name                = var.rt_name
  rt_rule_name           = var.rt_rule_name
  next_hop_in_ip_address = module.firewall.firewall_private_ip_address
  rt_spoke1_subnet_id    = module.network.subnet_spoke1_id
  rt_tags                = var.rt_tags
}

module "storage" {
  source               = "./modules/storage"
  resource_group_name  = azurerm_resource_group.rg-grp.name
  location             = azurerm_resource_group.rg-grp.location
  storage_tags         = var.storage_tags
  storage_account_name = var.storage_account_name
}

module "monitor" {
  source              = "./modules/monitor"
  resource_group_name = azurerm_resource_group.rg-grp.name
  location            = azurerm_resource_group.rg-grp.location
  storage_account_id  = module.storage.storage_account_id
  vmss_target_id      = module.compute.vmss_target_id
  firewall_target_id  = module.firewall.firewall_target_id
  log_analytics_name  = var.log_analytics_name
}
