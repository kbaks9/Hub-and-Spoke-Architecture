variable "resource_group_name" {
  description = "Name of the resource group for Terraform state"
  type        = string
  default     = "rg-tfstate"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "UK South"
}

variable "storage_account_name" {
  description = "Name of the storage account for Terraform state"
  type        = string
  default     = "storage9972007"
}

variable "storage_container_name" {
  description = "Blob container for Terraform state"
  type        = string
  default     = "tfstate"
}
