terraform {
  # The project backend already uses Terraform 1.9+,
  # so we keep the same version requirement here.
  required_version = ">= 1.9"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"

      # Keep the AzureRM provider compatible with
      # the foundation configuration created by Person A.
      version = "~> 4.0"
    }
  }
}

# AzureRM is the Terraform provider used to create
# and manage Microsoft Azure resources.
provider "azurerm" {
  features {}
}
