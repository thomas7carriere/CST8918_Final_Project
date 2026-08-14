# Azure region required by the team's project contract.
variable "location" {
  description = "Azure region where the project resources will be deployed"
  type        = string
  default     = "canadacentral"
}

# Main resource group for the final project infrastructure.
variable "resource_group_name" {
  description = "Name of the resource group containing the project infrastructure"
  type        = string
  default     = "cst8918-final-project-group-7"
}

# Address space for the main project virtual network.
variable "vnet_address_space" {
  description = "CIDR address space assigned to the project virtual network"
  type        = list(string)
  default     = ["10.0.0.0/14"]
}
