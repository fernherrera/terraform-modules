<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |
| random | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.sql_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_mssql_firewall_rule.firewall_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_firewall_rule) | resource |
| [azurerm_mssql_server.mssql](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server) | resource |
| [azurerm_mssql_server_transparent_data_encryption.tde](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server_transparent_data_encryption) | resource |
| [azurerm_mssql_virtual_network_rule.network_rules](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_virtual_network_rule) | resource |
| [random_password.sql_admin](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [azurerm_mssql_server.mssql_e](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/mssql_server) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| administrator\_login | (Optional) The administrator login name for the new server. Required unless azuread\_authentication\_only in the azuread\_administrator block is true. When omitted, Azure will generate a default username which cannot be subsequently changed. Changing this forces a new resource to be created. | `any` | `null` | no |
| administrator\_login\_password | (Optional) The password associated with the administrator\_login user. Needs to comply with Azure's Password Policy. Required unless azuread\_authentication\_only in the azuread\_administrator block is true. | `any` | `null` | no |
| azuread\_administrator | (Optional) An azuread\_administrator block. | `any` | `null` | no |
| connection\_policy | (Optional) The connection policy the server will use. Possible values are Default, Proxy, and Redirect. Defaults to Default. | `string` | `"Default"` | no |
| existing | (Optional) Whether to reference an existing resource group. | `bool` | `false` | no |
| firewall\_rules | (Optional) One or more firewall\_rules blocks. | `map` | `{}` | no |
| identity | (Optional) An identity block. | `any` | `null` | no |
| keyvault\_id | n/a | `any` | `null` | no |
| location | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `any` | n/a | yes |
| minimum\_tls\_version | (Optional) The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server. Valid values are: 1.0, 1.1 , 1.2 and Disabled. Defaults to 1.2. | `string` | `"1.2"` | no |
| name | (Required) The name of the Microsoft SQL Server. This needs to be globally unique within Azure. Changing this forces a new resource to be created. | `any` | n/a | yes |
| outbound\_network\_restriction\_enabled | (Optional) Whether outbound network traffic is restricted for this server. Defaults to false. | `bool` | `false` | no |
| primary\_user\_assigned\_identity\_id | (Optional) Specifies the primary user managed identity id. Required if type is UserAssigned and should be combined with identity\_ids. | `any` | `null` | no |
| public\_network\_access\_enabled | (Optional) Whether public network access is allowed for this server. Defaults to true. | `bool` | `true` | no |
| resource\_group\_name | (Required) The name of the resource group in which to create the Microsoft SQL Server. Changing this forces a new resource to be created. | `any` | n/a | yes |
| server\_version | (Required) The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server). Changing this forces a new resource to be created. | `any` | n/a | yes |
| tags | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| transparent\_data\_encryption\_key\_vault\_key\_id | (Optional) The fully versioned Key Vault Key URL (e.g. 'https://<YourVaultName>.vault.azure.net/keys/<YourKeyName>/<YourKeyVersion>) to be used as the Customer Managed Key(CMK/BYOK) for the Transparent Data Encryption(TDE) layer. | `any` | `null` | no |
| virtual\_network\_rules | (Optional) A list of one or more virtual\_network\_rule blocks. | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| fully\_qualified\_domain\_name | The fully qualified domain name of the Azure SQL Server (e.g. myServerName.database.windows.net) |
| id | The Microsoft SQL Server ID. |
| name | The Microsoft SQL Server name. |
| restorable\_dropped\_database\_ids | A list of dropped restorable database IDs on the server. |
<!-- END_TF_DOCS -->