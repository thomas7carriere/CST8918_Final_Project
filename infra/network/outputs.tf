# Resource group information required by the platform layer.
output "resource_group_name" {
  description = "Name of the main project resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Azure region of the main project resource group"
  value       = azurerm_resource_group.main.location
}


# VNet information that can be consumed by other Terraform roots.
output "vnet_id" {
  description = "Resource ID of the project virtual network"
  value       = azurerm_virtual_network.main.id
}


# AKS will later use these subnet IDs.
output "prod_subnet_id" {
  description = "Resource ID of the production subnet"
  value       = azurerm_subnet.prod.id
}

output "test_subnet_id" {
  description = "Resource ID of the test subnet"
  value       = azurerm_subnet.test.id
}


# Expose these as well for completeness and future infrastructure use.
output "dev_subnet_id" {
  description = "Resource ID of the development subnet"
  value       = azurerm_subnet.dev.id
}

output "admin_subnet_id" {
  description = "Resource ID of the administrative subnet"
  value       = azurerm_subnet.admin.id
}
