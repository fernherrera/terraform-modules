#------------------------
# Local declarations
#------------------------
locals {
  id                   = element(coalescelist(data.azurerm_subnet.snet_e.*.id, azurerm_subnet.snet.*.id, [""]), 0)
  name                 = element(coalescelist(data.azurerm_subnet.snet_e.*.name, azurerm_subnet.snet.*.name, [""]), 0)
  resource_group_name  = element(coalescelist(data.azurerm_subnet.snet_e.*.resource_group_name, azurerm_subnet.snet.*.resource_group_name, [""]), 0)
  virtual_network_name = element(coalescelist(data.azurerm_subnet.snet_e.*.virtual_network_name, azurerm_subnet.snet.*.virtual_network_name, [""]), 0)
  address_prefixes     = element(coalescelist(data.azurerm_subnet.snet_e.*.address_prefixes, azurerm_subnet.snet.*.address_prefixes, [""]), 0)
  location             = element(data.azurerm_resource_group.rgrp.*.location, 0)
  tags                 = merge(try(var.tags, {}))
}

#----------------------------------------------------------
# Subnets 
#----------------------------------------------------------
data "azurerm_resource_group" "rgrp" {
  name = var.resource_group_name
}

data "azurerm_subnet" "snet_e" {
  count = var.existing == true ? 1 : 0

  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
}

resource "azurerm_subnet" "snet" {
  count = var.existing == false ? 1 : 0

  name                 = var.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.address_prefixes

  private_endpoint_network_policies_enabled     = try(var.private_endpoint_network_policies_enabled, null)
  private_link_service_network_policies_enabled = try(var.private_link_service_network_policies_enabled, null)
  service_endpoints                             = try(var.service_endpoints, null)
  service_endpoint_policy_ids                   = try(var.service_endpoint_policy_ids, null)

  dynamic "delegation" {
    for_each = try(var.delegation, {})

    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}

#-----------------------------------------------
# Network Security Group
#-----------------------------------------------
resource "azurerm_network_security_group" "nsg" {
  count = var.existing == false ? 1 : 0

  name                = lower("${var.name}-nsg")
  resource_group_name = var.resource_group_name
  location            = local.location
  tags                = local.tags

  dynamic "security_rule" {
    for_each = concat(try(var.nsg_inbound_rules, []), try(var.nsg_outbound_rules, []))

    content {
      name                         = try(security_rule.value.name, "Default_Rule")
      description                  = try(security_rule.value.description, "")
      priority                     = try(security_rule.value.priority, "100")
      direction                    = try(security_rule.value.direction, "Inbound")
      access                       = try(security_rule.value.access, "Allow")
      protocol                     = try(security_rule.value.protocol, "Tcp")
      source_port_range            = try(security_rule.value.source_port_range, "")
      source_port_ranges           = try(security_rule.value.source_port_ranges, [])
      destination_port_range       = try(security_rule.value.destination_port_range, "")
      destination_port_ranges      = try(security_rule.value.destination_port_ranges, [])
      source_address_prefix        = try(security_rule.value.source_address_prefix, var.address_prefixes)
      source_address_prefixes      = try(security_rule.value.source_address_prefixes, [])
      destination_address_prefix   = try(security_rule.value.destination_address_prefix, var.address_prefixes)
      destination_address_prefixes = try(security_rule.value.destination_address_prefixes, [])
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "nsg-assoc" {
  count = var.existing == false ? 1 : 0

  subnet_id                 = local.id
  network_security_group_id = azurerm_network_security_group.nsg[0].id
}