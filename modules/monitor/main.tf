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

resource "azurerm_monitor_action_group" "ag_vmss" {
  name                = "ag-vmss-alerts"
  resource_group_name = var.resource_group_name
  short_name          = "vmss-plt"

  email_receiver {
    name          = "vmss-alerts"
    email_address = "realbaks33@gmail.com"
  }
}

resource "azurerm_monitor_metric_alert" "vmss_cpu" {
  name                = "alert-vmss-high-cpu"
  resource_group_name = var.resource_group_name
  scopes              = [var.vmss_target_id]

  description = "VMSS CPU usage above 80%"
  severity    = 2

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  window_size = "PT5M"
  frequency   = "PT1M"

  action {
    action_group_id = azurerm_monitor_action_group.ag_vmss.id
  }
}

resource "azurerm_monitor_metric_alert" "vmss_availability" {
  name                = "alert-vmss-availability"
  resource_group_name = azurerm_resource_group.rg.name
  scopes              = [var.vmss_target_id]

  description = "VMSS availability issue"
  severity    = 1

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Available VM Instances"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 2
  }

  window_size = "PT5M"
  frequency   = "PT1M"

  action {
    action_group_id = azurerm_monitor_action_group.ag_vmss.id
  }
}
