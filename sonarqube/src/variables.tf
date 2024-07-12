#--------------------------------------
# Variables
#--------------------------------------
variable "org_code" {
  description = "(Required)"
  default     = "imx"
}
variable "product" {
  description = "(Required)  Defaults to 'sonarqube'."
  default     = "sonarqube"
}

variable "environment" {
  description = "(Required) Defaults to 'sbx'."
  default     = "sbx"
}

variable "region" {
  description = "(Required) Defaults to East US 'eastus'."
  default     = "eastus"
}

variable "tags" {
  description = "(Optional) Resource tags to assign to all resources."
  default     = {}
}

variable "network" {
  description = "(Required)"
  default     = {}
}

variable "keyvault" {
  description = "(Optional)"
  default     = {}
}

variable "custom_hostname" {
  description = "(Optional)"
  default     = {}
}

variable "use_private_endpoints" {
  description = "(Optional)"
  default     = false
}

variable "private_dns_resource_group" {
  description = "(Optional)"
  default     = null
}

# Subsciprion IDs for management landing zones.
variable "management_subscription_id" {
  description = "Sets the Subscription ID to use for Management resources (Private DNS). Set this if your Private DNS zones are in a different subscription."
  type        = string
  default     = ""
}