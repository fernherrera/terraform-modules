# module "diagnostic_settings" {
#   source = "../monitor/diagnostic_settings"
#   count  = var.diagnostic_profiles == null ? 0 : 1

#   resource_id       = azurerm_application_insights.appinsights.id
#   resource_location = var.location
#   diagnostics       = var.diagnostics
#   profiles          = var.diagnostic_profiles
# }