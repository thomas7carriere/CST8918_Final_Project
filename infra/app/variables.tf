variable "aks_cluster_name" {
  description = "AKS cluster name for this environment. STUB."
  type        = string
  default     = "stub-aks-cluster"
}

variable "aks_resource_group_name" {
  description = "Resource group holding the AKS cluster. STUB."
  type        = string
  default     = "cst8918-final-project-group-7"
}

variable "acr_login_server" {
  description = "ACR login server, e.g. cst8918grp7.azurecr.io. STUB."
  type        = string
  default     = "stub.azurecr.io"
}

variable "redis_host" {
  description = "Azure Cache for Redis hostname. STUB."
  type        = string
  default     = "stub-redis.redis.cache.windows.net"
}

variable "redis_access_key" {
  description = "Azure Cache for Redis primary access key. STUB."
  type        = string
  sensitive   = true
  default     = "stub-access-key"
}

variable "redis_ssl_port" {
  description = "Azure Cache for Redis TLS port. STUB."
  type        = number
  default     = 6380
}

variable "image_name" {
  description = "Image repository name within the ACR."
  type        = string
  default     = "weather-app"
}

variable "image_tag" {
  description = "Image tag to deploy. CI sets TF_VAR_image_tag to the commit SHA."
  type        = string
}

variable "weather_api_key" {
  description = "OpenWeather API key. CI sets TF_VAR_weather_api_key from the GitHub secret."
  type        = string
  sensitive   = true
}

variable "use_remote_state" {
  description = "Read platform values from platform.tfstate instead of the stub variables. Flip to true once B has applied."
  type        = bool
  default     = false
}

variable "replicas_by_env" {
  description = "Replica count per environment."
  type        = map(number)
  default = {
    test = 1
    prod = 2
  }
}
