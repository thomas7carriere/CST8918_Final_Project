terraform {
  required_version = ">= 1.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tfstate" {
  name     = "cst8918-tfstate-group-7"
  location = "canadacentral"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "cst8918tfstategrp7"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  blob_properties {
    versioning_enabled = true
  }
}

resource "azurerm_storage_container" "tfstate" {
  name               = "tfstate"
  storage_account_id = azurerm_storage_account.tfstate.id
}

output "resource_group_name"  { value = azurerm_resource_group.tfstate.name }
output "storage_account_name" { value = azurerm_storage_account.tfstate.name }
output "container_name"       { value = azurerm_storage_container.tfstate.name }