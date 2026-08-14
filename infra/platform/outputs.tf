# Application-facing outputs are maps keyed by environment.
# Anoop can select them using ["test"] / ["prod"] or workspace.

output "aks_cluster_name" {
  description = "AKS cluster names keyed by environment"

  value = {
    test = module.aks_test.name
    prod = module.aks_prod.name
  }
}

output "aks_resource_group" {
  description = "AKS resource groups keyed by environment"

  value = {
    test = local.resource_group_name
    prod = local.resource_group_name
  }
}

output "acr_login_server" {
  description = "ACR login server used by the application"
  value       = azurerm_container_registry.main.login_server
}

output "redis_host" {
  description = "Redis hostnames keyed by environment"

  value = {
    test = azurerm_redis_cache.test.hostname
    prod = azurerm_redis_cache.prod.hostname
  }
}

output "redis_access_key" {
  description = "Redis access keys keyed by environment"
  sensitive   = true

  value = {
    test = azurerm_redis_cache.test.primary_access_key
    prod = azurerm_redis_cache.prod.primary_access_key
  }
}

output "redis_ssl_port" {
  description = "Redis TLS ports keyed by environment"

  value = {
    test = azurerm_redis_cache.test.ssl_port
    prod = azurerm_redis_cache.prod.ssl_port
  }
}
