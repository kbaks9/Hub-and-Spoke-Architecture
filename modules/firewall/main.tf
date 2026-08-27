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

resource "azurerm_firewall_policy" "policy" {
  name                = var.firewall_policy_name
  resource_group_name = var.resource_group_name
  location            = var.location

  # Standard tier doesn't support these:
  # intrusion_detection {
  #   mode = "Deny"
  # }
}

resource "azurerm_firewall_policy_rule_collection_group" "rules" {
  name               = "firewall-rule-collection"
  firewall_policy_id = azurerm_firewall_policy.policy.id
  priority           = 100

  application_rule_collection {
    name     = "allow-linux-updates"
    priority = 100
    action   = "Allow"

    rule {
      name              = "Allow-http-https"
      source_addresses  = ["10.1.1.0/24"]
      destination_fqdns = ["*"]

      protocols {
        type = "Http"
        port = 80
      }

      protocols {
        type = "Https"
        port = 443
      }
    }
  }

  network_rule_collection {
    name     = "allow-dns"
    priority = 200
    action   = "Allow"

    rule {
      name                  = "dns-outbound"
      source_addresses      = ["10.1.1.0/24"]
      destination_addresses = ["168.63.129.16"]
      destination_ports     = ["53"]
      protocols             = ["UDP", "TCP"]
    }
  }
}
