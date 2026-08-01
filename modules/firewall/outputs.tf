output "firewall_private_ip_address" {
  value = azurerm_firewall.firewall.ip_configuration[0].private_ip_address
}

output "firewall_target_id" {
  value = azurerm_firewall.firewall.id
}
