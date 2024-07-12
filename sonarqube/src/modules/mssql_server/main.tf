#----------------------------------------------------------
# Local declarations
#----------------------------------------------------------
locals {
  id                              = element(coalescelist(data.azurerm_mssql_server.mssql_e.*.id, azurerm_mssql_server.mssql.*.id, [""]), 0)
  name                            = element(coalescelist(data.azurerm_mssql_server.mssql_e.*.name, azurerm_mssql_server.mssql.*.name, [""]), 0)
  fully_qualified_domain_name     = element(coalescelist(data.azurerm_mssql_server.mssql_e.*.fully_qualified_domain_name, azurerm_mssql_server.mssql.*.fully_qualified_domain_name, [""]), 0)
  restorable_dropped_database_ids = element(coalescelist(data.azurerm_mssql_server.mssql_e.*.restorable_dropped_database_ids, azurerm_mssql_server.mssql.*.restorable_dropped_database_ids, [""]), 0)
}

#----------------------------------------------------------
# Generate sql server random admin password 
# if not provided in the attribute administrator_login_password
#----------------------------------------------------------
resource "random_password" "sql_admin" {
  count = var.existing == false && try(var.administrator_login_password, null) == null ? 1 : 0

  length           = 128
  special          = true
  upper            = true
  numeric          = true
  override_special = "$#%"
}

#----------------------------------------------------------
# Store the generated password into keyvault
#----------------------------------------------------------
resource "azurerm_key_vault_secret" "sql_admin_password" {
  count = var.existing == false && try(var.administrator_login_password, null) == null ? 1 : 0

  name         = format("%s-password", var.name)
  value        = random_password.sql_admin.0.result
  key_vault_id = var.keyvault_id

  lifecycle {
    ignore_changes = [
      value
    ]
  }
}

#----------------------------------------------------------
# MSSQL Server
#----------------------------------------------------------
data "azurerm_mssql_server" "mssql_e" {
  count = var.existing == true ? 1 : 0

  name                = var.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_mssql_server" "mssql" {
  count = var.existing == false ? 1 : 0

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  version                              = try(var.server_version, "12.0")
  administrator_login                  = try(var.azuread_administrator.azuread_authentication_only, false) == true ? null : var.administrator_login
  administrator_login_password         = try(var.azuread_administrator.azuread_authentication_only, false) == true && try(var.administrator_login_password, null) == null ? null : try(random_password.sql_admin.0.result, null)
  public_network_access_enabled        = try(var.public_network_access_enabled, null)
  connection_policy                    = try(var.connection_policy, null)
  minimum_tls_version                  = try(var.minimum_tls_version, null)
  outbound_network_restriction_enabled = try(var.outbound_network_restriction_enabled, null)
  primary_user_assigned_identity_id    = try(var.primary_user_assigned_identity_id, null)

  dynamic "azuread_administrator" {
    for_each = try(var.azuread_administrator, null) != null ? [1] : []

    content {
      azuread_authentication_only = try(var.azuread_administrator.azuread_authentication_only, false)
      login_username              = try(var.azuread_administrator.login_username, null)
      object_id                   = try(var.azuread_administrator.object_id, null)
      tenant_id                   = try(var.azuread_administrator.tenant_id, null)
    }
  }

  dynamic "identity" {
    for_each = try(var.identity, null) != null ? [1] : []

    content {
      type         = var.identity.value.type
      identity_ids = concat(var.identity.value.managed_identities, [])
    }
  }

  # This is a hack, to avoid terraform from always destorying and recreating SQL server and attached DBs.azuread_administrator {
  # TODO: Find out why it thinks location keeps changing.
  lifecycle {
    ignore_changes = [
      location
    ]
  }
}

#----------------------------------------------------------
# Transparent data encryption
#----------------------------------------------------------
resource "azurerm_mssql_server_transparent_data_encryption" "tde" {
  count = try(var.transparent_data_encryption_key_vault_key_id, null) != null ? 1 : 0

  server_id        = local.id
  key_vault_key_id = var.transparent_data_encryption_key_vault_key_id
}

#----------------------------------------------------------
# Azure SQL Firewall Rules
#----------------------------------------------------------
resource "azurerm_mssql_firewall_rule" "firewall_rules" {
  for_each = try(var.firewall_rules, {})

  name             = each.value.name
  server_id        = local.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}

#----------------------------------------------------------
# Azure SQL Virtual Network Rules
#----------------------------------------------------------
resource "azurerm_mssql_virtual_network_rule" "network_rules" {
  for_each = try(var.virtual_network_rules, {})

  depends_on = [azurerm_mssql_server.mssql]

  name      = each.value.name
  server_id = local.id
  subnet_id = each.value.subnet_id

  ignore_missing_vnet_service_endpoint = try(each.value.ignore_missing_vnet_service_endpoint, null)
}