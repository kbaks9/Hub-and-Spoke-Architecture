resource "azurerm_network_security_group" "nsg_spoke1" {
  name                = var.nsg_spoke1_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.spoke1_tags
}

resource "azurerm_network_security_group" "nsg_spoke2" {
  name                = var.nsg_spoke2_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.spoke2_tags
}

resource "azurerm_network_security_group" "nsg_monitor" {
  name                = var.nsg_monitor_name
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Next to add is this:
# resource "azurerm_subnet_network_security_group_association" "spoke1" {
#   subnet_id                 = azurerm_subnet.spoke1_subnet.id
#   network_security_group_id = azurerm_network_security_group.nsg_spoke1.id
# }

# resource "azurerm_subnet_network_security_group_association" "spoke2" {
#   subnet_id                 = azurerm_subnet.spoke2_subnet.id
#   network_security_group_id = azurerm_network_security_group.nsg_spoke2.id
# }

# resource "azurerm_subnet_network_security_group_association" "monitor" {
#   subnet_id                 = azurerm_subnet.monitor_subnet.id
#   network_security_group_id = azurerm_network_security_group.nsg_monitor.id
# }



