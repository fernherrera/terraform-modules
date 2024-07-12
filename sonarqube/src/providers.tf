#----------------------------------------------------------
# Terraform Providers
#----------------------------------------------------------
provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "management"
  subscription_id = local.management_subscription_id
  features {}
}
