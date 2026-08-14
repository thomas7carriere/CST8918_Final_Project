# Store the network Terraform state remotely in the shared
# Azure Storage backend created by Person A (Thomas).
#
# Remote state allows the team and GitHub Actions to work
# with the same infrastructure state instead of keeping
# terraform.tfstate on one developer's laptop.
terraform {
  backend "azurerm" {
    resource_group_name  = "cst8918-tfstate-group-7"
    storage_account_name = "cst8918tfstategrp7"
    container_name       = "tfstate"

    # Each Terraform root has a separate state file.
    # This state file belongs only to infra/network.
    key = "network.tfstate"
  }
}
