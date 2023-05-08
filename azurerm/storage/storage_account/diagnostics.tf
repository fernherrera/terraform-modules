# module "diagnostics" {
#   source = "../../monitor/diagnostic_settings"
#   count  = var.diagnostic_profiles == {} ? 0 : 1

#   resource_id       = azurerm_storage_account.stg.id
#   resource_location = azurerm_storage_account.stg.location
#   diagnostics       = var.diagnostics
#   profiles          = try(var.diagnostic_profiles, {})
# }
