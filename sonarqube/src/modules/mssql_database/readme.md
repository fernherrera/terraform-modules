<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |
| null | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_mssql_database.mssqldb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_database) | resource |
| [null_resource.set_db_permissions](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [azurerm_storage_account.mssqldb_tdp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloud | n/a | `any` | n/a | yes |
| elastic\_pool\_id | n/a | `any` | `null` | no |
| location | n/a | `any` | n/a | yes |
| managed\_identities | n/a | `any` | `null` | no |
| name | Name of the resource. | `string` | n/a | yes |
| server\_id | n/a | `any` | n/a | yes |
| server\_name | n/a | `any` | n/a | yes |
| settings | n/a | `any` | n/a | yes |
| sqlcmd\_dbname | n/a | `any` | `null` | no |
| storage\_accounts | n/a | `any` | n/a | yes |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | n/a |
| name | n/a |
| server\_fqdn | n/a |
| server\_id | n/a |
| server\_name | n/a |
<!-- END_TF_DOCS -->