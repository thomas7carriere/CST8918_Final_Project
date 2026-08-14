# ============================================================
# AZURE CONTAINER REGISTRY
# ============================================================
# Stores the Remix Weather App Docker image.
resource "azurerm_container_registry" "main" {
  name                = "cst8918finalacrgrp7"
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name
  location            = data.terraform_remote_state.network.outputs.resource_group_location

  sku           = "Basic"
  admin_enabled = false
}

# ============================================================
# TEST AKS
# ============================================================
# One fixed Standard_B2s node as required.
module "aks_test" {
  source = "../../modules/aks"

  cluster_name        = "cst8918-aks-test"
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name
  location            = data.terraform_remote_state.network.outputs.resource_group_location
  subnet_id           = data.terraform_remote_state.network.outputs.test_subnet_id

  kubernetes_version = var.kubernetes_version
  vm_size            = var.aks_vm_size

  enable_auto_scaling = false
  node_count          = 1
}

# ============================================================
# PRODUCTION AKS
# ============================================================
# Production cluster autoscaling: minimum 1, maximum 3 nodes.
module "aks_prod" {
  source = "../../modules/aks"

  cluster_name        = "cst8918-aks-prod"
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name
  location            = data.terraform_remote_state.network.outputs.resource_group_location
  subnet_id           = data.terraform_remote_state.network.outputs.prod_subnet_id

  kubernetes_version = var.kubernetes_version
  vm_size            = var.aks_vm_size

  enable_auto_scaling = true
  min_count           = 1
  max_count           = 3
}

# ============================================================
# ACR PULL PERMISSIONS
# ============================================================
# Allows each AKS kubelet identity to pull images from ACR.
# Without this, pods may fail with ImagePullBackOff.
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
  location            = data.terraform_remote_state.network.outputs.resource_group_location
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name

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
  location            = data.terraform_remote_state.network.outputs.resource_group_location
  resource_group_name = data.terraform_remote_state.network.outputs.resource_group_name

  capacity = 0
  family   = "C"
  sku_name = "Basic"

  non_ssl_port_enabled = false
  minimum_tls_version  = "1.2"
}
