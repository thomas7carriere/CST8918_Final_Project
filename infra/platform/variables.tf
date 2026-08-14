variable "kubernetes_version" {
  description = "Kubernetes version required by the project"
  type        = string
  default     = "1.34.9"
}

variable "aks_vm_size" {
  description = "VM size used by AKS nodes"
  type        = string
  default     = "Standard_B2s"
}
