variable "app_name" {
  description = "Base name for all Kubernetes objects."
  type        = string
  default     = "weather-app"
}

variable "environment" {
  description = "Environment label (test or prod). Used for labels only."
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace to deploy into."
  type        = string
  default     = "default"
}

variable "create_namespace" {
  description = "Create the namespace, or assume it already exists."
  type        = bool
  default     = false
}

# --- Image -------------------------------------------------------------------

variable "image_repository" {
  description = "Full image repository, e.g. myacr.azurecr.io/weather-app. No tag."
  type        = string
}

variable "image_tag" {
  description = "Image tag. CI passes the commit SHA."
  type        = string
}

# --- Runtime -----------------------------------------------------------------

variable "replicas" {
  description = "Number of pod replicas."
  type        = number
  default     = 2
}

variable "container_port" {
  description = "Port the Remix server listens on. Injected as PORT. Keep above 1024 so a non-root container can bind it."
  type        = number
  default     = 3000

  validation {
    condition     = var.container_port > 1024
    error_message = "The container runs as a non-root user and cannot bind a privileged port."
  }
}

variable "service_port" {
  description = "Port the LoadBalancer Service exposes."
  type        = number
  default     = 80
}

variable "service_type" {
  description = "Kubernetes Service type."
  type        = string
  default     = "LoadBalancer"
}

# --- Secrets -----------------------------------------------------------------

variable "weather_api_key" {
  description = "OpenWeather API key. Comes from the WEATHER_API_KEY GitHub secret."
  type        = string
  sensitive   = true
}

variable "redis_host" {
  description = "Azure Cache for Redis hostname, from the platform state."
  type        = string
}

variable "redis_access_key" {
  description = "Azure Cache for Redis primary access key, from the platform state."
  type        = string
  sensitive   = true
}

variable "redis_ssl_port" {
  description = "Redis TLS port. Azure Cache for Redis uses 6380."
  type        = number
  default     = 6380
}

# --- Resources ---------------------------------------------------------------

variable "resource_requests" {
  description = "Pod resource requests. Standard_B2s nodes are small, so keep these modest."
  type = object({
    cpu    = string
    memory = string
  })
  default = {
    cpu    = "100m"
    memory = "128Mi"
  }
}

variable "resource_limits" {
  description = "Pod resource limits."
  type = object({
    cpu    = string
    memory = string
  })
  default = {
    cpu    = "500m"
    memory = "512Mi"
  }
}
