# Get the Azure subscription used by GitHub Actions/Terraform.
# We use it to construct the subnet resource IDs.
data "azurerm_client_config" "current" {}

locals {
  # These names match the resources created by infra/network.
  resource_group_name = "cst8918-final-project-group-7"
  location            = "canadacentral"
  vnet_name           = "cst8918-final-vnet"

  # The network root is applied before the platform root.
  # Therefore these subnet IDs will exist when platform is applied.
  test_subnet_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${local.vnet_name}/subnets/test-subnet"

  prod_subnet_id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${local.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${local.vnet_name}/subnets/prod-subnet"
}

# ============================================================
# AZURE CONTAINER REGISTRY
# ============================================================
# Stores the Remix Weather App container images.
resource "azurerm_container_registry" "main" {
  name                = "cst8918finalacrgrp7"
  resource_group_name = local.resource_group_name
  location            = local.location

  sku           = "Basic"
  admin_enabled = false
}

# ============================================================
# TEST AKS CLUSTER
# ============================================================
# Test uses one Standard_B2s worker node.
module "aks_test" {
  source = "../../modules/aks"

  cluster_name        = "cst8918-aks-test"
  resource_group_name = local.resource_group_name
  location            = local.location
  subnet_id           = local.test_subnet_id

  kubernetes_version = var.kubernetes_version
  vm_size            = var.aks_vm_size

  enable_auto_scaling = false
  node_count          = 1
}

# ============================================================
# PRODUCTION AKS CLUSTER
# ============================================================
# Production automatically scales between 1 and 3 nodes.
module "aks_prod" {
  source = "../../modules/aks"

  cluster_name        = "cst8918-aks-prod"
  resource_group_name = local.resource_group_name
  location            = local.location
  subnet_id           = local.prod_subnet_id

  kubernetes_version = var.kubernetes_version
  vm_size            = var.aks_vm_size

  enable_auto_scaling = true
  min_count           = 1
  max_count           = 3
}

# ============================================================
# ACR PULL PERMISSIONS
# ============================================================
# Give each AKS kubelet identity permission to pull images
# from the Azure Container Registry.
resource "azurerm_role_assignment" "acr_pull_test" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks_test.kubelet_object_id
}

resource "azurerm_role_assignment" "acr_pull_prod" {
  scope                = azurerm_container_registry.main.id
  role_definition_name = "AcrPull"
  principal_id         = module.aks_prod.kubelet_object_id
}

# ============================================================
# TEST REDIS
# ============================================================
resource "azurerm_redis_cache" "test" {
  name                = "cst8918-redis-test-grp7"
  location            = local.location
  resource_group_name = local.resource_group_name

  capacity = 0
  family   = "C"
  sku_name = "Basic"

  non_ssl_port_enabled = false
  minimum_tls_version  = "1.2"
}

# ============================================================
# PRODUCTION REDIS
# ============================================================
resource "azurerm_redis_cache" "prod" {
  name                = "cst8918-redis-prod-grp7"
  location            = local.location
  resource_group_name = local.resource_group_name

  capacity = 0
  family   = "C"
  sku_name = "Basic"

  non_ssl_port_enabled = false
  minimum_tls_version  = "1.2"
}
