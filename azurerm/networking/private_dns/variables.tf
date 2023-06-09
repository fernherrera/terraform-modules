variable "name" {
  description = "(Required) Specifies the name. Changing this forces a new resource to be created."
  type        = string
}

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

variable "records" {
  description = "Configuration object - DNS records."
}

variable "vnet_links" {
  description = "Configuration object - Private DNS Zone Virtual Network Links."
  default     = {}
}

variable "vnets" {
  default = {}
}
