resource "azurerm_storage_account" "storage" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = "Standard"
  account_replication_type        = "ZRS"
  tags                            = var.storage_tags
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
}
