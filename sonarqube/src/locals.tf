#----------------------------------------------------------
# Terraform Local Variables
#----------------------------------------------------------
locals {
  # Resource Naming
  base_resource_name   = lower("${var.org_code}-${var.environment}-${var.product}")
  storage_account_name = substr(replace(lower("${var.org_code}${var.environment}${var.product}st"), "/[^a-zA-Z0-9]/", ""), 0, 24)

  location = try(var.region, "eastus")

  # Tags
  default_tags = {
    Environment = "${var.environment}"
    Product     = "SonarQube"
    Terraform   = "true"
  }
  tags = try(var.tags, local.default_tags)

  # Subscription IDs for other subscription
  management_subscription_id = coalesce(var.management_subscription_id, data.azurerm_client_config.current.subscription_id)

  # Private DNS records for Private links
  # Private DNS lookups will use a different provider to access a different subscription (if necessary) with alias of management.
  private_dns = {
    database = {
      name                = "privatelink.database.windows.net"
      resource_group_name = try(var.private_dns_resource_group, null)
    }

    file = {
      name                = "privatelink.file.core.windows.net"
      resource_group_name = try(var.private_dns_resource_group, null)
    }

    web = {
      name                = "privatelink.azurewebsites.net"
      resource_group_name = try(var.private_dns_resource_group, null)
    }
  }
}