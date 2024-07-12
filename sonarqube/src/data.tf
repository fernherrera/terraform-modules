#----------------------------------------------------------
# Azure Subscription and client data
#----------------------------------------------------------
data "azuread_client_config" "current" {}
data "azurerm_client_config" "current" {}
data "azurerm_subscription" "current" {}

data "azurerm_client_config" "management" {
  provider = azurerm.management
}