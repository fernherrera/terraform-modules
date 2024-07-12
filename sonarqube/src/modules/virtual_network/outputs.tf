output "id" {
  description = "The virtual NetworkConfiguration ID."
  value       = local.id
}

output "name" {
  description = "The name of the virtual network."
  value       = local.name
}

output "resource_group_name" {
  description = "The name of the resource group in which to create the virtual network."
  value       = local.resource_group_name
}

output "location" {
  description = "The location/region where the virtual network is created."
  value       = local.location
}

output "address_space" {
  description = "The list of address spaces used by the virtual network."
  value       = local.address_space
}

output "guid" {
  description = "The GUID of the virtual network."
  value       = local.guid
}

output "subnets" {
  description = "The subnets created in the virtual network."
  value       = module.subnets
}