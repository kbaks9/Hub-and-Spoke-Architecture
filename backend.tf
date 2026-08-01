terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "storage9972007"
    container_name       = "tfstate"
    key                  = "dev.tfstate"
  }
}
