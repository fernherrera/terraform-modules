variable "resource_group_name" {
  description = "(Required) The name of the resource group in which to create the Data Factory Linked Service."
}

variable "name" {
  description = "Name of the API Management service instance"
  type        = string
}

variable "data_factory_id" {
  description = "(Required) The Data Factory ID in which to associate the Linked Service with. Changing this forces a new resource."
}

variable "connection_string" {
  default = null
}

variable "integration_runtime_name" {
  description = "(Optional) The integration runtime reference to associate with the Data Factory Linked Service."
  default     = null
}

variable "storage_account" {
  description = "Storage account to attach"
  default     = null
}

variable "settings" {
  description = "Used for general parameter."
}