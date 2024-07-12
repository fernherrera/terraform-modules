#-------------------------------
# Local Declarations
#-------------------------------
locals {
  app_insights = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = try(var.application_insight.instrumentation_key, null),
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = try(var.application_insight.connection_string, null)
  }

  app_settings = merge(
    try(var.app_settings, {}),
  var.application_insight == null ? {} : local.app_insights)
}

#---------------------------------------------------------
# Linux Web App Service 
#---------------------------------------------------------
resource "azurerm_linux_web_app" "web_app" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.service_plan_id
  tags                = var.tags

  app_settings                       = local.app_settings
  client_affinity_enabled            = try(var.client_affinity_enabled, null)
  client_certificate_enabled         = try(var.client_certificate_enabled, null)
  client_certificate_mode            = try(var.client_certificate_mode, null)
  client_certificate_exclusion_paths = try(var.client_certificate_exclusion_paths, null)
  enabled                            = try(var.enabled, null)
  https_only                         = try(var.https_only, null)
  public_network_access_enabled      = try(var.public_network_access_enabled, null)
  key_vault_reference_identity_id    = try(var.key_vault_reference_identity_id, null)
  virtual_network_subnet_id          = try(var.virtual_network_subnet_id, null)
  zip_deploy_file                    = try(var.zip_deploy_file, null)

  dynamic "auth_settings" {
    for_each = try(var.auth_settings, null) != null ? [1] : []

    content {
      enabled                        = try(var.auth_settings.enabled, false)
      additional_login_parameters    = try(var.auth_settings.additional_login_parameters, null)
      allowed_external_redirect_urls = try(var.auth_settings.allowed_external_redirect_urls, null)
      default_provider               = try(var.auth_settings.default_provider, null)
      issuer                         = try(var.auth_settings.issuer, null)
      runtime_version                = try(var.auth_settings.runtime_version, null)
      token_refresh_extension_hours  = try(var.auth_settings.token_refresh_extension_hours, null)
      token_store_enabled            = try(var.auth_settings.token_store_enabled, null)
      unauthenticated_client_action  = try(var.auth_settings.unauthenticated_client_action, null)

      dynamic "active_directory" {
        for_each = try(var.auth_settings.active_directory, null) != null ? [1] : []

        content {
          client_id         = var.auth_settings.active_directory.client_id
          client_secret     = try(var.auth_settings.active_directory.client_secret, null)
          allowed_audiences = try(var.auth_settings.active_directory.allowed_audiences, null)
        }
      }

      dynamic "facebook" {
        for_each = try(var.auth_settings.facebook, null) != null ? [1] : []

        content {
          app_id       = var.auth_settings.facebook.app_id
          app_secret   = var.auth_settings.facebook.app_secret
          oauth_scopes = try(var.auth_settings.facebook.oauth_scopes, null)
        }
      }

      dynamic "google" {
        for_each = try(var.auth_settings.google, null) != null ? [1] : []

        content {
          client_id     = var.auth_settings.google.client_id
          client_secret = var.auth_settings.google.client_secret
          oauth_scopes  = try(var.auth_settings.google.oauth_scopes, null)
        }
      }

      dynamic "microsoft" {
        for_each = try(var.auth_settings.microsoft, null) != null ? [1] : []

        content {
          client_id     = var.auth_settings.microsoft.client_id
          client_secret = var.auth_settings.microsoft.client_secret
          oauth_scopes  = try(var.auth_settings.microsoft.oauth_scopes, null)
        }
      }

      dynamic "twitter" {
        for_each = try(var.auth_settings.twitter, null) != null ? [1] : []

        content {
          consumer_key    = var.auth_settings.twitter.consumer_key
          consumer_secret = var.auth_settings.twitter.consumer_secret
        }
      }

      dynamic "github" {
        for_each = try(var.auth_settings.github, null) != null ? [1] : []

        content {
          client_id                  = var.auth_settings.github.client_id
          client_secret              = var.auth_settings.github.client_secret
          client_secret_setting_name = var.auth_settings.github.client_secret_setting_name
          oauth_scopes               = try(var.auth_settings.github.oauth_scopes, null)
        }
      }
    }
  }

  dynamic "backup" {
    for_each = try(var.backup, null) != null ? [1] : []

    content {
      name                = var.backup.name
      enabled             = var.backup.enabled
      storage_account_url = var.backup.storage_account_url

      dynamic "schedule" {
        for_each = try(var.backup.schedule, null) != null ? [1] : []

        content {
          frequency_interval       = var.backup.schedule.frequency_interval
          frequency_unit           = try(var.backup.schedule.frequency_unit, null)
          keep_at_least_one_backup = try(var.backup.schedule.keep_at_least_one_backup, null)
          retention_period_days    = try(var.backup.schedule.retention_period_days, null)
          start_time               = try(var.backup.schedule.start_time, null)
        }
      }
    }
  }

  dynamic "connection_string" {
    for_each = var.connection_strings

    content {
      name  = try(connection_string.value.name, null)
      type  = try(connection_string.value.type, null)
      value = try(connection_string.value.value, null)
    }
  }

  dynamic "identity" {
    for_each = try(var.identity, null) != null ? [1] : []

    content {
      type         = var.identity.type
      identity_ids = concat(var.identity.managed_identities, [])
    }
  }

  dynamic "logs" {
    for_each = try(var.logs, null) != null ? [1] : []

    content {
      detailed_error_messages = try(var.logs.detailed_error_messages, false)
      failed_request_tracing  = try(var.logs.failed_request_tracing, false)

      dynamic "application_logs" {
        for_each = try(var.logs.application_logs, null) != null ? [1] : []

        content {
          file_system_level = try(var.logs.application_logs.file_system_level, null)

          dynamic "azure_blob_storage" {
            for_each = try(var.logs.application_logs.azure_blob_storage, null) != null ? [1] : []

            content {
              level             = var.logs.application_logs.azure_blob_storage.level
              retention_in_days = var.logs.application_logs.azure_blob_storage.retention_in_days
              sas_url           = try(var.logs.application_logs.azure_blob_storage.sas_url, local.logs.application_logs.azure_blob_storage.sas_url)
            }
          }
        }
      }

      dynamic "http_logs" {
        for_each = try(var.logs.http_logs, null) != null ? [1] : []

        content {
          dynamic "azure_blob_storage" {
            for_each = try(var.logs.http_logs.azure_blob_storage, null) != null ? [1] : []

            content {
              retention_in_days = try(var.logs.http_logs.azure_blob_storage.retention_in_days, false)
              sas_url           = try(var.logs.http_logs.azure_blob_storage.sas_url, false)
            }
          }

          dynamic "file_system" {
            for_each = try(var.logs.http_logs.file_system, null) != null ? [1] : []

            content {
              retention_in_days = try(var.logs.http_logs.file_system.retention_in_days, false)
              retention_in_mb   = try(var.logs.http_logs.file_system.retention_in_mb, false)
            }
          }
        }
      }
    }
  }

  dynamic "site_config" {
    for_each = try(var.site_config, null) != null ? [1] : []

    content {
      always_on                                     = try(var.site_config.always_on, true)
      api_definition_url                            = try(var.site_config.api_definition_url, null)
      api_management_api_id                         = try(var.site_config.api_management_api_id, null)
      app_command_line                              = try(var.site_config.app_command_line, null)
      auto_heal_enabled                             = try(var.site_config.aut_heal_setting, null)
      container_registry_managed_identity_client_id = try(var.site_config.container_registry_managed_identity_client_id, null)
      container_registry_use_managed_identity       = try(var.site_config.container_registry_use_managed_identity, false)
      default_documents                             = try(var.site_config.default_documents, null)
      ftps_state                                    = try(var.site_config.ftps_state, null)
      health_check_path                             = try(var.site_config.health_check_path, null)
      health_check_eviction_time_in_min             = try(var.site_config.health_check_eviction_time_in_min, null)
      http2_enabled                                 = try(var.site_config.http2_enabled, null)
      load_balancing_mode                           = try(var.site_config.load_balancing_mode, null)
      local_mysql_enabled                           = try(var.site_config.local_mysql_enabled, false)
      managed_pipeline_mode                         = try(var.site_config.managed_pipeline_mode, null)
      minimum_tls_version                           = try(var.site_config.minimum_tls_version, null)
      remote_debugging_enabled                      = try(var.site_config.remote_debugging_enabled, null)
      remote_debugging_version                      = try(var.site_config.remote_debugging_version, null)
      scm_minimum_tls_version                       = try(var.site_config.scm_minimum_tls_version, null)
      scm_use_main_ip_restriction                   = try(var.site_config.scm_use_main_ip_restriction, null)
      use_32_bit_worker                             = try(var.site_config.use_32_bit_worker, null)
      vnet_route_all_enabled                        = try(var.site_config.vnet_route_all_enabled, null)
      websockets_enabled                            = try(var.site_config.websockets_enabled, null)
      worker_count                                  = try(var.site_config.worker_count, null)

      dynamic "auto_heal_setting" {
        for_each = try(var.site_config.auto_heal_setting, null) != null ? [1] : []

        content {
          dynamic "action" {
            for_each = try(var.site_config.auto_heal_setting.action, null) != null ? [1] : []

            content {
              action_type                    = try(var.site_config.auto_heal_setting.action.action_type, null)
              minimum_process_execution_time = try(var.site_config.auto_heal_setting.action.minimum_process_execution_time, null)
            }
          }

          dynamic "trigger" {
            for_each = try(var.site_config.auto_heal_setting.trigger, null) != null ? [1] : []

            content {
              dynamic "requests" {
                for_each = try(var.site_config.auto_heal_setting.trigger.requests, null) != null ? [1] : []

                content {
                  count    = try(var.site_config.auto_heal_setting.trigger.requests.count, null)
                  interval = try(var.site_config.auto_heal_setting.trigger.requests.interval, null)
                }
              }

              dynamic "slow_request" {
                for_each = try(var.site_config.auto_heal_setting.trigger.slow_request, null) != null ? [1] : []

                content {
                  count      = try(var.site_config.auto_heal_setting.trigger.slow_request.count, null)
                  interval   = try(var.site_config.auto_heal_setting.trigger.slow_request.interval, null)
                  time_taken = try(var.site_config.auto_heal_setting.trigger.slow_request.time_taken, null)
                  path       = try(var.site_config.auto_heal_setting.trigger.slow_request.path, null)
                }
              }

              dynamic "status_code" {
                for_each = try(var.site_config.auto_heal_setting.trigger.status_code, null) != null ? [1] : []

                content {
                  count             = try(var.site_config.auto_heal_setting.trigger.status_code.count, null)
                  interval          = try(var.site_config.auto_heal_setting.trigger.status_code.interval, null)
                  status_code_range = try(var.site_config.auto_heal_setting.trigger.status_code.status_code_range, null)
                  sub_status        = try(var.site_config.auto_heal_setting.trigger.status_code.sub_status, null)
                  path              = try(var.site_config.auto_heal_setting.trigger.status_code.path, null)
                }
              }
            }
          }
        }
      }

      dynamic "application_stack" {
        for_each = try(var.site_config.application_stack, null) != null ? [1] : []

        content {
          docker_image_name   = try(var.site_config.application_stack.docker_image_name, null)
          docker_registry_url = try(var.site_config.application_stack.docker_registry_url, null)
          dotnet_version      = try(var.site_config.application_stack.dotnet_version, null)
          go_version          = try(var.site_config.application_stack.go_version, null)
          java_server         = try(var.site_config.application_stack.java_server, null)
          java_server_version = try(var.site_config.application_stack.java_server_version, null)
          java_version        = try(var.site_config.application_stack.java_version, null)
          node_version        = try(var.site_config.application_stack.node_version, null)
          php_version         = try(var.site_config.application_stack.php_version, null)
          python_version      = try(var.site_config.application_stack.python_version, null)
          ruby_version        = try(var.site_config.application_stack.ruby_version, null)
        }
      }

      dynamic "cors" {
        for_each = try(var.site_config.cors, null) != null ? [1] : []

        content {
          allowed_origins     = try(var.site_config.cors.allowed_origins, null)
          support_credentials = try(var.site_config.cors.support_credentials, null)
        }
      }

      dynamic "ip_restriction" {
        for_each = try(var.site_config.ip_restriction, [])

        content {
          ip_address                = try(ip_restriction.value.ip_address, null)
          service_tag               = try(ip_restriction.value.service_tag, null)
          virtual_network_subnet_id = try(ip_restriction.value.virtual_network_subnet_id, null)
          name                      = try(ip_restriction.value.name, null)
          priority                  = try(ip_restriction.value.priority, null)
          action                    = try(ip_restriction.value.action, null)

          dynamic "headers" {
            for_each = try(ip_restriction.value.headers, [])

            content {
              x_azure_fdid      = try(headers.value.x_azure_fdid, null)
              x_fd_health_probe = try(headers.value.x_fd_health_prob, null)
              x_forwarded_for   = try(headers.value.x_forwarded_for, null)
              x_forwarded_host  = try(headers.value.x_forwarded_host, null)
            }
          }
        }
      }

      dynamic "scm_ip_restriction" {
        for_each = try(var.site_config.scm_ip_restriction, [])

        content {
          ip_address                = try(scm_ip_restriction.value.ip_address, null)
          service_tag               = try(scm_ip_restriction.value.service_tag, null)
          virtual_network_subnet_id = try(scm_ip_restriction.value.virtual_network_subnet_id, null)
          name                      = try(scm_ip_restriction.value.name, null)
          priority                  = try(scm_ip_restriction.value.priority, null)
          action                    = try(scm_ip_restriction.value.action, null)

          dynamic "headers" {
            for_each = try(scm_ip_restriction.value.headers, [])

            content {
              x_azure_fdid      = try(headers.value.x_azure_fdid, null)
              x_fd_health_probe = try(headers.value.x_fd_health_prob, null)
              x_forwarded_for   = try(headers.value.x_forwarded_for, null)
              x_forwarded_host  = try(headers.value.x_forwarded_host, null)
            }
          }
        }
      }
    }
  }

  dynamic "sticky_settings" {
    for_each = try(var.sticky_settings, null) != null ? [1] : []

    content {
      app_setting_names       = try(var.sticky_settings.app_setting_names, false)
      connection_string_names = try(var.sticky_settings.connection_string_name, false)
    }
  }

  dynamic "storage_account" {
    for_each = try(var.storage_account, {})

    content {
      access_key   = try(storage_account.value.access_key, null)
      account_name = try(storage_account.value.account_name, null)
      name         = try(storage_account.value.name, null)
      share_name   = try(storage_account.value.share_name, null)
      type         = try(storage_account.value.type, null)
      mount_path   = try(storage_account.value.mount_path, null)
    }
  }

  lifecycle {
    ignore_changes = [
      # Hack, for some reason auth_settings keeps triggering an update.
      auth_settings
    ]
  }
}

#---------------------------------------------------------
# Linux Web App Custom hostname bindings
#---------------------------------------------------------
# Get existing Key Vault Certificates
data "azurerm_key_vault_certificate" "cert" {
  for_each = {
    for k, cert in var.certificates : k => cert
    if try(cert.key_vault_id, null) != null
  }

  name         = each.value.name
  key_vault_id = each.value.key_vault_id
}

# Add App Service Certificates from Key Vault certificates
resource "azurerm_app_service_certificate" "appcert" {
  for_each = data.azurerm_key_vault_certificate.cert

  name                = each.value.name
  resource_group_name = var.resource_group_name
  location            = var.location
  key_vault_secret_id = each.value.id
}

# Bind the webapp to the domain. 
resource "azurerm_app_service_custom_hostname_binding" "app_service" {
  for_each = try(var.custom_hostname_bindings, {})

  app_service_name    = azurerm_linux_web_app.web_app.name
  resource_group_name = var.resource_group_name
  hostname            = each.value.hostname
  ssl_state           = try(each.value.ssl_state, null)
  thumbprint          = try(each.value.thumbprint, null)

  # Ignore ssl_state and thumbprint as they are managed using
  # azurerm_app_service_certificate_binding.example
  lifecycle {
    ignore_changes = [ssl_state, thumbprint]
  }
}

# Bind certificate to the webapp. 
resource "azurerm_app_service_certificate_binding" "cb" {
  for_each = {
    for k, b in var.custom_hostname_bindings : k => b
    if try(b.certificate_key, null) != null
  }

  depends_on = [azurerm_app_service_certificate.appcert]

  hostname_binding_id = azurerm_app_service_custom_hostname_binding.app_service[each.key].id
  certificate_id      = azurerm_app_service_certificate.appcert[each.value.certificate_key].id
  ssl_state           = try(each.value.ssl_state, "SniEnabled")
}

#---------------------------------------------------------
# Linux Web App Source Control Configuration.
#---------------------------------------------------------
resource "azurerm_app_service_source_control" "scm" {
  for_each = try(var.source_control, {})

  app_id   = azurerm_linux_web_app.web_app.id
  repo_url = try(var.source_control.repo_url, null)
  branch   = try(var.source_control.branch.main, "")

  use_manual_integration = try(var.source_control.use_manual_integration, false)
  rollback_enabled       = try(var.source_control.rollback_enabled, false)
  use_local_git          = try(var.source_control.use_local_git, null)
  use_mercurial          = try(var.source_control.use_mercurial, null)

  dynamic "github_action_configuration" {
    for_each = try(var.source_control.github_action_configuration, null) != null ? [1] : []

    content {
      generate_workflow_file = try(var.source_control.github_action_configuration.generate_workflow_file, true)

      dynamic "code_configuration" {
        for_each = try(var.source_control.github_action_configuration.code_configuration, null) != null ? [1] : []

        content {
          runtime_stack   = var.source_control.github_action_configuration.code_configuration.runtime_stack
          runtime_version = var.source_control.github_action_configuration.code_configuration.runtime_version
        }
      }

      dynamic "container_configuration" {
        for_each = try(var.source_control.github_action_configuration.container_configuration, null) != null ? [1] : []

        content {
          image_name        = var.source_control.github_action_configuration.container_configuration.image_name
          registry_url      = var.source_control.github_action_configuration.container_configuration.registry_url
          registry_password = try(var.source_control.github_action_configuration.container_configuration.registry_password, null)
          registry_username = try(var.source_control.github_action_configuration.container_configuration.registry_username, null)
        }
      }
    }
  }
}

#---------------------------------------------------------
# App Service Resource currently doesn't support to set docker compose
# See: https://github.com/hashicorp/terraform-provider-azurerm/issues/16290
#---------------------------------------------------------
resource "azapi_update_resource" "update_linux_web_app" {
  count = try(var.site_config.docker_compose_file, null) == null ? 0 : 1

  resource_id = azurerm_linux_web_app.web_app.id
  type        = "Microsoft.Web/sites@2022-03-01"
  body = jsonencode({
    properties = {
      siteConfig = {
        linuxFxVersion = "COMPOSE|${base64encode(file(var.site_config.docker_compose_file))}"
      }
    }
  })
}