# ============================================================
# RESOURCE GROUP
# ============================================================
# This resource group contains the main Azure infrastructure
# for the CST8918 final project.
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}


# ============================================================
# VIRTUAL NETWORK
# ============================================================
# The /14 VNet provides enough address space for the four
# required /16 environment subnets:
#
#   prod  -> 10.0.0.0/16
#   test  -> 10.1.0.0/16
#   dev   -> 10.2.0.0/16
#   admin -> 10.3.0.0/16
#
# Separating environments into subnets provides clear network
# boundaries and makes the IP address itself identify the
# environment.
resource "azurerm_virtual_network" "main" {
  name                = "cst8918-final-vnet"
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}


# ============================================================
# PRODUCTION SUBNET
# ============================================================
# Reserved for production workloads.
# The production AKS cluster will use this network.
resource "azurerm_subnet" "prod" {
  name                 = "prod-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/16"]
}


# ============================================================
# TEST SUBNET
# ============================================================
# Reserved for test workloads.
# The test AKS cluster will use this network.
resource "azurerm_subnet" "test" {
  name                 = "test-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.1.0.0/16"]
}


# ============================================================
# DEVELOPMENT SUBNET
# ============================================================
# Reserved for development workloads.
# The assignment requires this subnet even though a
# development AKS cluster is not required.
resource "azurerm_subnet" "dev" {
  name                 = "dev-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.2.0.0/16"]
}


# ============================================================
# ADMIN SUBNET
# ============================================================
# Reserved for administrative or management workloads.
resource "azurerm_subnet" "admin" {
  name                 = "admin-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.3.0.0/16"]
}
