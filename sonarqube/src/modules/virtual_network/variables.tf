variable "name" {
  description = "(Required) The name of the virtual network. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the virtual network. Changing this forces a new resource to be created."
}

variable "location" {
  description = "(Required) The location/region where the virtual network is created. Changing this forces a new resource to be created."
}

variable "address_space" {
  description = "(Required) The address space that is used the virtual network. You can supply more than one address space. Note: Not required when existing is set to true."
  default     = null
}

variable "existing" {
  description = "(Optional) Whether to reference an existing resource group."
  default     = false
  type        = bool
}

variable "bgp_community" {
  description = "(Optional) The BGP community attribute in format <as-number>:<community-value>."
  default     = null
}

variable "ddos_protection_plan" {
  description = "(Optional) A ddos_protection_plan block."
  default     = null
}

variable "encryption" {
  description = "(Optional) A encryption block."
  default     = null
}

variable "dns_servers" {
  description = "(Optional) List of IP addresses of DNS servers"
  default     = null
}

variable "edge_zone" {
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Virtual Network should exist. Changing this forces a new Virtual Network to be created."
  default     = null
}

variable "flow_timeout_in_minutes" {
  description = "(Optional) The flow timeout in minutes for the Virtual Network, which is used to enable connection tracking for intra-VM flows. Possible values are between 4 and 30 minutes."
  default     = null
}

variable "subnets" {
  description = "(Optional) Can be specified multiple times to define multiple subnets."
  default     = {}
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource."
  default     = null
}
