variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region for the AKS cluster"
  type        = string
}

variable "subnet_id" {
  description = "Subnet resource ID used by the AKS node pool"
  type        = string
}

variable "vm_size" {
  description = "VM size used by AKS worker nodes"
  type        = string
  default     = "Standard_B2s"
}

variable "kubernetes_version" {
  description = "Kubernetes version used by AKS"
  type        = string
  default     = "1.32"
}

variable "enable_auto_scaling" {
  description = "Enable AKS node pool autoscaling"
  type        = bool
  default     = false
}

variable "node_count" {
  description = "Fixed node count when autoscaling is disabled"
  type        = number
  default     = 1
}

variable "min_count" {
  description = "Minimum node count when autoscaling is enabled"
  type        = number
  default     = 1
}

variable "max_count" {
  description = "Maximum node count when autoscaling is enabled"
  type        = number
  default     = 3
}
