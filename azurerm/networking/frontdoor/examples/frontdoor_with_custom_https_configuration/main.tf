# Azurerm Provider configuration
provider "azurerm" {
  features {}
}

module "frontdoor" {
  source  = "terraform-modules/azurerm/networking/frontdoor"
  version = "1.0.0"

  # By default, this module will not create a resource group. Location will be same as existing RG.
  # proivde a name to use an existing resource group, specify the existing resource group name, 
  # set the argument to `create_resource_group = true` to create new resrouce group.
  resource_group_name = "rg-shared-westeurope-01"
  location            = "westeurope"
  frontdoor_name      = "example-frontdoor51"

  routing_rules = [
    {
      name               = "exampleRoutingRule1"
      accepted_protocols = ["Http", "Https"]
      patterns_to_match  = ["/*"]
      frontend_endpoints = ["exampleFrontendEndpoint1"]
      forwarding_configuration = {
        forwarding_protocol = "MatchRequest"
        backend_pool_name   = "exampleBackendBing"
      }
    }
  ]

  backend_pool_load_balancing = [
    {
      name = "exampleLoadBalancingSettings1"
    }
  ]

  backend_pool_health_probes = [
    {
      name = "exampleHealthProbeSetting1"
    }
  ]

  backend_pools = [
    {
      name = "exampleBackendBing"
      backend = {
        host_header = "www.bing.com"
        address     = "www.bing.com"
        http_port   = 80
        https_port  = 443
      }
      load_balancing_name = "exampleLoadBalancingSettings1"
      health_probe_name   = "exampleHealthProbeSetting1"
    }
  ]

  # In order to enable the use of your own custom HTTPS certificate you must grant  
  # Azure Front Door Service access to your key vault. For instuctions on how to  
  # configure your Key Vault correctly. Please refer to the product documentation.
  # https://bit.ly/38FuAZv

  frontend_endpoints = [
    {
      name      = "exampleFrontendEndpoint1"
      host_name = "example-frontdoor51.azurefd.net"
    },
    {
      name      = "exampleFrontendEndpoint2"
      host_name = "example-frontdoor52.azurefd.net"
      custom_https_configuration = {
        certificate_source = "FrontDoor"
      }
    },
    {
      name      = "exampleFrontendEndpoint3"
      host_name = "example-frontdoor53.azurefd.net"
      custom_https_configuration = {
        certificate_source                         = "AzureKeyVault"
        azure_key_vault_certificate_vault_id       = "" # valid keyvalut id
        azure_key_vault_certificate_secret_name    = "" # valid certificate secret
        azure_key_vault_certificate_secret_version = "Latest"
      }
    }
  ]

  # (Optional) To enable Azure Monitoring for Azure Frontdoor
  # (Optional) Specify `storage_account_name` to save monitoring logs to storage. 
  log_analytics_workspace_name = "loganalytics-we-sharedtest2"

  # Adding TAG's to your Azure resources 
  tags = {
    ProjectName  = "demo-internal"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }
}