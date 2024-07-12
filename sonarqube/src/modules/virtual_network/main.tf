#------------------------
# Local declarations
#------------------------
locals {
  id                  = element(coalescelist(data.azurerm_virtual_network.vnet_e.*.id, azurerm_virtual_network.vnet.*.id, [""]), 0)
  name                = element(coalescelist(data.azurerm_virtual_network.vnet_e.*.name, azurerm_virtual_network.vnet.*.name, [""]), 0)
  resource_group_name = element(coalescelist(data.azurerm_virtual_network.vnet_e.*.resource_group_name, azurerm_virtual_network.vnet.*.resource_group_name, [""]), 0)
  location            = element(coalescelist(data.azurerm_virtual_network.vnet_e.*.location, azurerm_virtual_network.vnet.*.location, [""]), 0)
  address_space       = element(coalescelist(data.azurerm_virtual_network.vnet_e.*.address_space, azurerm_virtual_network.vnet.*.address_space, [""]), 0)
  guid                = element(coalescelist(data.azurerm_virtual_network.vnet_e.*.guid, azurerm_virtual_network.vnet.*.guid, [""]), 0)
}

#-------------------------------------
# Virtual Network
#-------------------------------------
data "azurerm_virtual_network" "vnet_e" {
  count = var.existing == true ? 1 : 0

  name                = var.name
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  count = var.existing == false ? 1 : 0

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags                = var.tags

  dynamic "ddos_protection_plan" {
    for_each = try(var.ddos_protection_plan, null) != null ? [1] : []

    content {
      id     = var.ddos_protection_plan.id
      enable = var.ddos_protection_plan.enable
    }
  }

  dynamic "encryption" {
    for_each = try(var.encryption, null) != null ? [1] : []

    content {
      enforcement = var.encryption.enforcement
    }
  }
}

#-------------------------------------
# Subnets
#-------------------------------------
module "subnets" {
  source   = "./subnet"
  for_each = try(var.subnets, {})

  name                 = each.value.name
  resource_group_name  = local.resource_group_name
  virtual_network_name = local.name
  address_prefixes     = try(each.value.address_prefixes, null)
  existing             = try(each.value.existing, false)

  delegation                                    = try(each.value.delegation, {})
  private_endpoint_network_policies_enabled     = try(each.value.private_endpoint_network_policies_enabled, null)
  private_link_service_network_policies_enabled = try(each.value.private_link_service_network_policies_enabled, null)
  service_endpoints                             = try(each.value.service_endpoints, null)
  service_endpoint_policy_ids                   = try(each.value.service_endpoint_policy_ids, null)
  nsg_inbound_rules                             = try(each.value.nsg_inbound_rules, [])
  nsg_outbound_rules                            = try(each.value.nsg_outbound_rules, [])
  tags                                          = var.tags
}