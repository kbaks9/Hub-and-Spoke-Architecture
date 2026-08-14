resource "azurerm_firewall" "firewall" {
  name                = var.firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  threat_intel_mode   = "Deny"
  firewall_policy_id  = azurerm_firewall_policy.policy.id

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = var.firewall_public_ip_address_id
  }
  tags = var.firewall_tags
}

resource "azurerm_firewall_policy" "f_policy" {
  name                = var.firewall_policy_name
  resource_group_name = var.resource_group_name
  location            = var.location

  intrusion_detection {
    mode = "Deny"
  }
}

resource "azurerm_firewall_application_rule_collection" "allow_http_https" {
  name                = "allow-linux-updates"
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = var.resource_group_name
  priority            = 100
  action              = "Allow"

  rule {
    name             = "Allow-http-https"
    source_addresses = ["10.1.1.0/24"]
    target_fqdns     = ["*"]

    protocol {
      type = "Http"
      port = 80
    }

    protocol {
      type = "Https"
      port = 443
    }
  }
}

resource "azurerm_firewall_network_rule_collection" "dns" {
  name                = "allow-dns"
  priority            = 200
  action              = "Allow"
  azure_firewall_name = azurerm_firewall.firewall.name
  resource_group_name = var.resource_group_name

  rule {
    name                  = "dns-outbound"
    source_addresses      = ["10.1.1.0/24"]
    destination_addresses = ["168.63.129.16"]
    destination_ports     = ["53"]
    protocols             = ["UDP", "TCP"]
  }
}
