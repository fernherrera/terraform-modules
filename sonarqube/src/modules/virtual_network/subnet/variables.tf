variable "name" {
  description = "(Required) The name of the subnet. Changing this forces a new resource to be created."
}

variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the subnet. Changing this forces a new resource to be created."
}

variable "virtual_network_name" {
  description = "(Required) The name of the virtual network to which to attach the subnet. Changing this forces a new resource to be created."
}

variable "address_prefixes" {
  description = "(Required) The address prefixes to use for the subnet. NOTE: Currently only a single address prefix can be set as the Multiple Subnet Address Prefixes Feature is not yet in public preview or general availability."
  default     = null
}

variable "existing" {
  description = "(Optional) Whether to reference an existing resource group."
  default     = false
  type        = bool
}

variable "delegation" {
  description = "(Optional) One or more delegation blocks."
  default     = []
}

variable "private_endpoint_network_policies_enabled" {
  description = "(Optional) Enable or Disable network policies for the private endpoint on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true."
  default     = null
}

variable "private_link_service_network_policies_enabled" {
  description = "(Optional) Enable or Disable network policies for the private link service on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true."
  default     = null
}

variable "service_endpoints" {
  description = "(Optional) The list of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage, Microsoft.Storage.Global and Microsoft.Web."
  default     = null
}

variable "service_endpoint_policy_ids" {
  description = "(Optional) The list of IDs of Service Endpoint Policies to associate with the subnet."
  default     = null
}

variable "nsg_inbound_rules" {
  description = "(Optional) A list of inbound Network Security Rules."
  default     = []
}

variable "nsg_outbound_rules" {
  description = "(Optional) A list of outbound Network Security rules."
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
