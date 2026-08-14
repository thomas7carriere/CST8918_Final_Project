# Reusable AKS module used for TEST and PROD.

resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name           = "system"
    vm_size        = var.vm_size
    vnet_subnet_id = var.subnet_id

    # TEST uses one fixed node.
    # PROD enables autoscaling between min_count and max_count.
    node_count = var.enable_auto_scaling ? null : var.node_count

    auto_scaling_enabled = var.enable_auto_scaling
    min_count            = var.enable_auto_scaling ? var.min_count : null
    max_count            = var.enable_auto_scaling ? var.max_count : null
  }

  # AKS uses a managed identity instead of stored credentials.
  identity {
    type = "SystemAssigned"
  }

  # Azure CNI networking with Kubernetes NetworkPolicy enabled.
  # This satisfies tfsec's network-policy security requirement.
  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }

  # Send AKS monitoring data to Azure Monitor / Log Analytics.
  # This satisfies tfsec's AKS logging requirement.
  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }
}
