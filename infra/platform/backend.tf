# Shared Azure Blob Storage backend created by Person A.
terraform {
  backend "azurerm" {
    resource_group_name  = "cst8918-tfstate-group-7"
    storage_account_name = "cst8918tfstategrp7"
    container_name       = "tfstate"
    key                  = "platform.tfstate"
  }
}
