terraform {
  required_version = ">= 1.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31"
    }
  }

  backend "azurerm" {
    resource_group_name  = "cst8918-tfstate-group-7"
    storage_account_name = "cst8918tfstategrp7"
    container_name       = "tfstate"
    key                  = "app.tfstate"
  }
}

provider "azurerm" {
  features {}
}

locals {
  # Workspace doubles as the environment name. The azurerm backend namespaces
  # non-default workspaces under the same state key, so this stays inside the
  # one-key-per-root contract.
  environment = terraform.workspace

  # Swap side of the stub. While use_remote_state is false everything reads
  # from the stub variables; flip it once B has applied and nothing else
  # in this file changes.
  platform = var.use_remote_state ? {
    aks_cluster_name        = data.terraform_remote_state.platform[0].outputs.aks_cluster_name[local.environment]
    aks_resource_group_name = data.terraform_remote_state.platform[0].outputs.aks_resource_group_name[local.environment]
    acr_login_server        = data.terraform_remote_state.platform[0].outputs.acr_login_server
    redis_host              = data.terraform_remote_state.platform[0].outputs.redis_host[local.environment]
    redis_access_key        = data.terraform_remote_state.platform[0].outputs.redis_access_key[local.environment]
    } : {
    aks_cluster_name        = var.aks_cluster_name
    aks_resource_group_name = var.aks_resource_group_name
    acr_login_server        = var.acr_login_server
    redis_host              = var.redis_host
    redis_access_key        = var.redis_access_key
  }
}

data "terraform_remote_state" "platform" {
  count   = var.use_remote_state ? 1 : 0
  backend = "azurerm"

  config = {
    resource_group_name  = "cst8918-tfstate-group-7"
    storage_account_name = "cst8918tfstategrp7"
    container_name       = "tfstate"
    key                  = "platform.tfstate"
  }
}

data "azurerm_kubernetes_cluster" "this" {
  count               = var.use_remote_state ? 1 : 0
  name                = local.platform.aks_cluster_name
  resource_group_name = local.platform.aks_resource_group_name
}

# If B enables AAD-integrated RBAC on the clusters, kube_config comes back
# empty for a non-admin identity and this needs kube_admin_config instead.
# Worth confirming with B before the first real apply.
provider "kubernetes" {
  host = try(
    data.azurerm_kubernetes_cluster.this[0].kube_config[0].host,
    "https://localhost:6443"
  )
  client_certificate = try(
    base64decode(data.azurerm_kubernetes_cluster.this[0].kube_config[0].client_certificate),
    ""
  )
  client_key = try(
    base64decode(data.azurerm_kubernetes_cluster.this[0].kube_config[0].client_key),
    ""
  )
  cluster_ca_certificate = try(
    base64decode(data.azurerm_kubernetes_cluster.this[0].kube_config[0].cluster_ca_certificate),
    ""
  )
}

module "weather_app" {
  source = "../../modules/weather-app"

  environment = local.environment
  namespace   = "weather-app-${local.environment}"

  create_namespace = true

  image_repository = "${local.platform.acr_login_server}/${var.image_name}"
  image_tag        = var.image_tag

  replicas = var.replicas_by_env[local.environment]

  weather_api_key  = var.weather_api_key
  redis_host       = local.platform.redis_host
  redis_access_key = local.platform.redis_access_key
}

output "app_url" {
  description = "Public URL of the deployed app."
  value       = module.weather_app.app_url
}

output "deployed_image" {
  description = "Image reference that was deployed."
  value       = module.weather_app.deployed_image
}
