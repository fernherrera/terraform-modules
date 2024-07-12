output "id" {
  description = "The subnet ID."
  value       = local.id
}

output "name" {
  description = "The name of the subnet. Changing this forces a new resource to be created."
  value       = local.name
}

output "resource_group_name" {
  description = "The name of the resource group in which the subnet is created in."
  value       = local.resource_group_name
}

output "virtual_network_name" {
  description = "The name of the virtual network in which the subnet is created in."
  value       = local.virtual_network_name
}

output "address_prefixes" {
  description = "The address prefixes for the subnet"
  value       = local.address_prefixes
}
