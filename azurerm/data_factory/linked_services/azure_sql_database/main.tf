resource "azurerm_data_factory_linked_service_azure_sql_database" "linked_service_azure_sql_database" {
  name                     = var.name
  resource_group_name      = var.resource_group_name
  data_factory_id          = var.data_factory_id
  description              = try(var.description, null)
  integration_runtime_name = try(var.integration_runtime_name, null)
  annotations              = try(var.annotations, null)
  parameters               = try(var.parameters, null)
  additional_properties    = try(var.additional_properties, null)
  connection_string        = var.connection_string
}