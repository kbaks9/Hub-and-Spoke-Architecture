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

resource "azurerm_subnet_network_security_group_association" "spoke1" {
  subnet_id                 = var.subnet_spoke1_id
  network_security_group_id = azurerm_network_security_group.nsg_spoke1.id
}

resource "azurerm_subnet_network_security_group_association" "spoke2" {
  subnet_id                 = var.subnet_spoke2_id
  network_security_group_id = azurerm_network_security_group.nsg_spoke2.id
}

### Allow ###
## Inbound ##
# Spoke1 allows HTTPS from Application Gateway
resource "azurerm_network_security_rule" "allow_inbound_appgw_https_spoke1" {
  name                        = "allow-https-from-appgw-spoke1"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "10.0.2.0/24" # App Gateway subnet
  destination_address_prefix  = "*"           # Spoke1 subnet (implicit)
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_spoke1.name
}

# Spoke1 allows SSH from Bastion
resource "azurerm_network_security_rule" "allow_bastion_ssh_spoke1" {
  name                        = "allow-ssh-from-bastion-spoke1"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "10.0.3.0/26" # Bastion subnet
  destination_address_prefix  = "*"           # Spoke1 subnet (implicit)
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_spoke1.name
}

## Deny ##
resource "azurerm_network_security_rule" "deny_all_outbound_traffic_spoke1" {
  name                        = "deny-all-outbound-traffic"
  priority                    = 500
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_spoke1.name
}

### Allow ###
## Inbound ##
# Spoke2 allows App Gateway connection
resource "azurerm_network_security_rule" "allow_appgw_https_spoke2" {
  name                        = "allow-https-from-appgw-spoke2"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "10.0.2.0/24" # App Gateway subnet
  destination_address_prefix  = "*"           # Spoke2 subnet (implicit)
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_spoke2.name
}

# Spoke2 allows Bastion connection
resource "azurerm_network_security_rule" "allow_bastion_ssh_spoke2" {
  name                        = "allow-ssh-from-bastion-spoke2"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "10.0.3.0/26" # Bastion subnet
  destination_address_prefix  = "*"           # Spoke2 subnet (implicit)
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_spoke2.name
}


## Deny ##
resource "azurerm_network_security_rule" "deny_all_outbound_traffic_spoke2" {
  name                        = "deny-all-outbound-traffic"
  priority                    = 500
  direction                   = "Outbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.nsg_spoke2.name
}
