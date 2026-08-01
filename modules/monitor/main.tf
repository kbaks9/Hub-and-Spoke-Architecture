resource "azurerm_log_analytics_workspace" "workspace" {
  name                = var.log_analytics_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "vmss" {
  name                           = "vmss-platform-monitoring"
  target_resource_id             = var.vmss_target_id
  storage_account_id             = var.storage_account_id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.workspace.id
  log_analytics_destination_type = "Dedicated"

  enabled_metric {
    category = "AllMetrics"
  }
}

resource "azurerm_monitor_diagnostic_setting" "firewall" {
  name                           = "firewall-platform-monitoring"
  target_resource_id             = var.firewall_target_id
  storage_account_id             = var.storage_account_id
  log_analytics_workspace_id     = azurerm_log_analytics_workspace.workspace.id
  log_analytics_destination_type = "Dedicated"


  enabled_log {
    category_group = "allLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
