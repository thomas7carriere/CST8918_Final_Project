# Read networking information produced by infra/network.
data "terraform_remote_state" "network" {
  backend = "azurerm"

  config = {
    resource_group_name  = "cst8918-tfstate-group-7"
    storage_account_name = "cst8918tfstategrp7"
    container_name       = "tfstate"
    key                  = "network.tfstate"
  }
}
