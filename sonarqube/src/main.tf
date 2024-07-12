# Reasource Group
#----------------------------------------------------------
resource "azurerm_resource_group" "rg" {

  name     = "${local.base_resource_name}-rg-${local.location}"
  location = local.location
  tags     = local.tags
}

# Managed Identity
#----------------------------------------------------------
module "managed_identity" {
  source = "./modules/managed_identity"

  name                = "${local.base_resource_name}-id-${local.location}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  tags                = local.tags
}

# Key Vault
#----------------------------------------------------------
module "keyvault" {
  source = "./modules/keyvault"

  name                = var.keyvault.name
  resource_group_name = try(var.keyvault.resource_group_name, azurerm_resource_group.rg.name)
  location            = try(var.keyvault.location, local.location)
  existing            = try(var.keyvault.existing, false)
  tags                = local.tags

  client_config = data.azuread_client_config.current
  tenant_id     = data.azuread_client_config.current.tenant_id
  sku_name      = "standard"
  settings      = {}
}

# Keyvault access policies
module "keyvault_access_policy" {
  source = "./modules/keyvault_access_policies/access_policy"

  keyvault_id = module.keyvault.id
  tenant_id   = data.azuread_client_config.current.tenant_id
  object_id   = module.managed_identity.principal_id

  access_policy = {
    certificate_permissions = ["Get", "List"]
    key_permissions         = ["Get", "List"]
    secret_permissions      = ["Get", "List"]
  }
}

# Virtual Network
#----------------------------------------------------------
module "virtual_network" {
  source = "./modules/virtual_network"

  name                = var.network.name
  address_space       = try(var.network.address_space, null)
  resource_group_name = try(var.network.resource_group_name, azurerm_resource_group.rg.name)
  location            = try(var.network.location, local.location)
  existing            = try(var.network.existing, false)
  tags                = local.tags
}

# Subnets
#----------------------------------------------------------
module "data_subnet" {
  source = "./modules/virtual_network/subnet"

  name                 = "${local.base_resource_name}-data-snet-${local.location}"
  resource_group_name  = module.virtual_network.resource_group_name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = var.network.data_snet_address_prefixes
  tags                 = local.tags

  service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Storage",
    "Microsoft.Sql",
    "Microsoft.Web"
  ]
}

module "app_subnet" {
  source = "./modules/virtual_network/subnet"

  name                 = "${local.base_resource_name}-app-snet-${local.location}"
  resource_group_name  = module.virtual_network.resource_group_name
  virtual_network_name = module.virtual_network.name
  address_prefixes     = var.network.app_snet_address_prefixes
  tags                 = local.tags

  delegation = [
    {
      name = "Microsoft.Web.serverFarms"
      service_delegation = {
        name = "Microsoft.Web/serverFarms"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/action"
        ]
      }
    }
  ]

  service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Storage",
    "Microsoft.Sql",
    "Microsoft.Web"
  ]
}

# Storage Account
#----------------------------------------------------------
module "storage_account" {
  source = "./modules/storage_account"

  name                = local.storage_account_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  tags                = local.tags

  file_shares = {
    sonarqube_conf = {
      name             = "sonarqube-conf"
      access_tier      = "TransactionOptimized"
      quota            = 1024
      enabled_protocol = "SMB"
    }
    sonarqube_data = {
      name             = "sonarqube-data"
      access_tier      = "TransactionOptimized"
      quota            = 1024
      enabled_protocol = "SMB"
    }
    sonarqube_logs = {
      name             = "sonarqube-logs"
      access_tier      = "TransactionOptimized"
      quota            = 1024
      enabled_protocol = "SMB"
    }
    sonarqube_extensions = {
      name             = "sonarqube-extensions"
      access_tier      = "TransactionOptimized"
      quota            = 1024
      enabled_protocol = "SMB"
    }
    sonarqube_bundled_plugins = {
      name             = "sonarqube-bundled-plugins"
      access_tier      = "TransactionOptimized"
      quota            = 1024
      enabled_protocol = "SMB"
    }
  }
}

# SQL Server & Database
#----------------------------------------------------------
module "mssql_server" {
  source = "./modules/mssql_server"

  name                = "${local.base_resource_name}-sql-${local.location}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  tags                = local.tags
  connection_policy   = "Default"
  server_version      = "12.0"
  administrator_login = "sonar"
  keyvault_id         = try(module.keyvault.id, null)

  azuread_administrator = {
    azuread_authentication_only = false
    login_username              = "SQL_Managers"
    object_id                   = "c9022c57-7395-4f1e-8616-20bb924e8011"
    tenant_id                   = "baa48578-ea65-46d3-bf42-2a0bde23117d"
  }
}

module "mssql_database" {
  source = "./modules/mssql_database"

  name        = "SonarQube"
  tags        = local.tags
  server_id   = module.mssql_server.id
  server_name = module.mssql_server.name

  settings = {
    collation                   = "SQL_Latin1_General_CP1_CS_AS"
    sku_name                    = "GP_S_Gen5_1"
    min_capacity                = 1
    max_size_gb                 = 32
    auto_pause_delay_in_minutes = 120
  }
}

# App Service Plan
#----------------------------------------------------------
module "app_service_plan" {
  source = "./modules/app_service_plan"

  name                = "${local.base_resource_name}-plan-${local.location}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  tags                = local.tags
  os_type             = "Linux"
  sku_name            = "B2"
}

# App Service (Linux)
#----------------------------------------------------------
module "linux_web_app" {
  source = "./modules/app_service_linux"

  name                            = "${local.base_resource_name}-app-${local.location}"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = local.location
  tags                            = local.tags
  enabled                         = true
  https_only                      = true
  public_network_access_enabled   = true
  key_vault_reference_identity_id = module.managed_identity.id
  service_plan_id                 = module.app_service_plan.id
  virtual_network_subnet_id       = module.app_subnet.id

  identity = {
    type               = "UserAssigned"
    managed_identities = [module.managed_identity.id]
  }

  app_settings = {
    "SONAR_JDBC_PASSWORD" = "@Microsoft.KeyVault(SecretUri=${module.keyvault.vault_uri}secrets/${module.mssql_server.name}-password/)"
    "SONAR_JDBC_URL"      = "jdbc:sqlserver://${module.mssql_server.fully_qualified_domain_name}:1433;database=${module.mssql_database.name}"
    "SONAR_JDBC_USERNAME" = "sonar"
  }

  site_config = {
    application_stack = {
      docker_image_name   = "sonarqube:lts-community"
      docker_registry_url = "https://index.docker.io"
    }

    app_command_line          = "-Dsonar.search.javaAdditionalOpts=-Dnode.store.allow_mmap=false"
    http2_enabled             = true
    use_32_bit_worker_process = true
    vnet_route_all_enabled    = true

    ip_restriction = [
      {
        name                      = "CloudFlare-IPs-1"
        service_tag               = null
        ip_address                = "103.21.244.0/22"
        virtual_network_subnet_id = null
        action                    = "Allow"
        priority                  = 201
        headers                   = []
      },
      {
        name                      = "CloudFlare-IPs-2"
        service_tag               = null
        ip_address                = "103.22.200.0/22"
        virtual_network_subnet_id = null
        action                    = "Allow"
        priority                  = 202
        headers                   = []
      },
      {
        name                      = "CloudFlare-IPs-3"
        service_tag               = null
        ip_address                = "103.31.4.0/22"
        virtual_network_subnet_id = null
        action                    = "Allow"
        priority                  = 203
        headers                   = []
      },
      {
        name                      = "CloudFlare-IPs-4"
        service_tag               = null
        ip_address                = "104.16.0.0/13"
        virtual_network_subnet_id = null
        action                    = "Allow"
        priority                  = 204
        headers                   = []
      },
      {
        name                      = "CloudFlare-IPs-5"
        service_tag               = null
        ip_address                = "104.24.0.0/14"
        virtual_network_subnet_id = null
        action                    = "Allow"
        priority                  = 205
        headers                   = []
      },
      {
        name                      = "CloudFlare-IPs-6"
        service_tag               = null
        ip_address                = "108.162.192.0/18"
        virtual_network_subnet_id = null
        action                    = "Allow"
        priority                  = 206
        headers                   = []
      },
      {
        name                      = "CloudFlare-IPs-7"
        service_tag               = null
        ip_address                = "131.0.72.0/22"
        virtual_network_subnet_id = null
        action                    = "Allow"
        priority                  = 207
        headers                   = []
      },
      {
        name                      = "CloudFlare-IPs-8"
        service_tag               = null
        ip_address                = "141.101.64.0/18"
        virtual_network_subnet_id = null
        action                    = "Allow"
        priority                  = 208
        headers                   = []
      },
      {
        name                      = "CloudFlare-IPs-9"
        service_tag               = null
        ip_address                = "162.158.0.0/15"
        virtual_network_subnet_id = null
        action                    = "Allow"
        priority                  = 209
        headers                   = []
      },
      {
        name                      = "CloudFlare-IPs-10"
        service_tag               = null
        ip_address                = "172.64.0.0/13"
        virtual_network_subnet_id = null
        action                    = "Allow"
        priority                  = 210
        headers                   = []
      },
      {
        name                      = "CloudFlare-IPs-11"
        service_tag               = null
        ip_address                = "173.245.48.0/20"
        virtual_network_subnet_id = null
        action                    = "Allow"
        priority                  = 211
        headers                   = []
      },
      {
        name                      = "CloudFlare-IPs-12"
        service_tag               = null
        ip_address                = "188.114.96.0/20"
        virtual_network_subnet_id = null
        action                    = "Allow"
        priority                  = 212
        headers                   = []
      },
      {
        name                      = "CloudFlare-IPs-13"
        service_tag               = null
        ip_address                = "190.93.240.0/20"
        virtual_network_subnet_id = null
        action                    = "Allow"
        priority                  = 213
        headers                   = []
      },
      {
        name                      = "CloudFlare-IPs-14"
        service_tag               = null
        ip_address                = "197.234.240.0/22"
        virtual_network_subnet_id = null
        action                    = "Allow"
        priority                  = 214
        headers                   = []
      },
      {
        name                      = "CloudFlare-IPs-15"
        service_tag               = null
        ip_address                = "198.41.128.0/17"
        virtual_network_subnet_id = null
        action                    = "Allow"
        priority                  = 215
        headers                   = []
      },
      {
        name                      = "DenyAll"
        service_tag               = null
        ip_address                = "0.0.0.0/0"
        virtual_network_subnet_id = null
        action                    = "Deny"
        priority                  = 1000
        headers                   = []
      }
    ]
  }

  storage_account = {
    conf = {
      name         = "sonarqube-conf"
      type         = "AzureFiles"
      share_name   = "sonarqube-conf"
      mount_path   = "/opt/sonarqube/conf"
      account_name = module.storage_account.name
      access_key   = module.storage_account.primary_access_key
    }
    data = {
      name         = "sonarqube-data"
      type         = "AzureFiles"
      share_name   = "sonarqube-data"
      mount_path   = "/opt/sonarqube/data"
      account_name = module.storage_account.name
      access_key   = module.storage_account.primary_access_key
    }
    logs = {
      name         = "sonarqube-logs"
      type         = "AzureFiles"
      share_name   = "sonarqube-logs"
      mount_path   = "/opt/sonarqube/logs"
      account_name = module.storage_account.name
      access_key   = module.storage_account.primary_access_key
    }
    extensions = {
      name         = "sonarqube-extensions"
      type         = "AzureFiles"
      share_name   = "sonarqube-extensions"
      mount_path   = "/opt/sonarqube/extensions"
      account_name = module.storage_account.name
      access_key   = module.storage_account.primary_access_key
    }
    bundled-plugins = {
      name         = "sonarqube-bundled-plugins"
      type         = "AzureFiles"
      share_name   = "sonarqube-bundled-plugins"
      mount_path   = "/opt/sonarqube/lib/bundled-plugins"
      account_name = module.storage_account.name
      access_key   = module.storage_account.primary_access_key
    }
  }

  certificates = {
    ssl_cert = {
      name         = try(var.custom_hostname.certificate_name, null)
      key_vault_id = module.keyvault.id
    }
  }

  custom_hostname_bindings = {
    app_hostname = {
      hostname        = try(var.custom_hostname.hostname, null)
      certificate_key = "ssl_cert"
    }
  }

}

# Private Endpoints
#----------------------------------------------------------
# Private DNS zones.
data "azurerm_private_dns_zone" "dns" {
  provider = azurerm.management
  for_each = try(local.private_dns, {})

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

# Storage Account Private Endpoint
# Storage Account is one of the three diagnostics destination objects and for that reason requires the
# private endpoint to be done at the root module to prevent circular references
module "storage_account_private_endpoint" {
  source = "./modules/private_endpoint"
  count  = var.use_private_endpoints == true ? 1 : 0

  depends_on = [module.storage_account]

  name                = "${module.storage_account.name}-pep"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  tags                = local.tags
  subnet_id           = module.data_subnet.id

  private_service_connection = {
    name                           = "${module.storage_account.name}-pl"
    private_connection_resource_id = module.storage_account.id
    subresource_names              = ["file"]
  }

  private_dns_zone_group = {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.dns["file"].id]
  }
}

# SQL Server Private Endpoint
module "mssql_servers_private_endpoints" {
  source = "./modules/private_endpoint"
  count  = var.use_private_endpoints == true ? 1 : 0

  depends_on = [module.mssql_server]

  name                = "${module.mssql_server.name}-pep"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  tags                = local.tags
  subnet_id           = module.data_subnet.id

  private_service_connection = {
    name                           = "${module.storage_account.name}-pl"
    private_connection_resource_id = module.mssql_server.id
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group = {
    name                 = "default"
    private_dns_zone_ids = [data.azurerm_private_dns_zone.dns["database"].id]
  }
}