terraform {
  required_version = ">= 1.3.5"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.77.0"
    }

    azapi = {
      source  = "azure/azapi"
      version = "~> 1.7"
    }
  }
}