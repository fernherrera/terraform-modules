variable "create_resource_group" {
  description = "Whether to create resource group and use it for all networking resources"
  default     = false
}

variable "resource_group_name" {
  description = "A container that holds related resources for an Azure solution"
  default     = ""
}

variable "location" {
  description = "The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table'"
  default     = ""
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "name" {
  description = "Name of the API Management service instance"
  type        = string
}

variable "tenant_id" {
  description = ""
}

variable "settings" {
  description = "(Required) Used to handle passthrough paramenters."
}

variable "client_config" {
  description = "Client configuration object (see module README.md)."
}

variable "vnets" {
  default = {}
}

variable "diagnostics" {
  default = {}
}

variable "resource_groups" {
  default = {}
}

variable "private_dns" {
  default = {}
}

variable "azuread_groups" {
  default = {}
}

variable "managed_identities" {
  default = {}
}