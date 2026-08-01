resource "azurerm_route_table" "spokes_rt" {
  name                = var.rt_name
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.rt_tags
}

resource "azurerm_route" "spokes_default" {
  name                   = var.rt_rule_name
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.spokes_rt.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.next_hop_in_ip_address
}

resource "azurerm_subnet_route_table_association" "spoke1_assoc" {
  subnet_id      = var.rt_spoke1_subnet_id
  route_table_id = azurerm_route_table.spokes_rt.id
}
