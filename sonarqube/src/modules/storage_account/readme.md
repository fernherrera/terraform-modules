<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| container | ./container | n/a |
| data\_lake\_filesystem | ./data_lake_filesystem | n/a |
| file\_share | ./file_share | n/a |
| management\_policy | ./management_policy | n/a |
| queue | ./queue | n/a |
| table | ./table | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_backup_container_storage_account.container](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_container_storage_account) | resource |
| [azurerm_storage_account.stg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |
| [azurerm_storage_account.stg_e](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_tier | (Optional) Defines the access tier for BlobStorage, FileStorage and StorageV2 accounts. Valid options are Hot and Cool, defaults to Hot. | `string` | `"Hot"` | no |
| account\_kind | (Optional) Defines the Kind of account. Valid options are BlobStorage, BlockBlobStorage, FileStorage, Storage and StorageV2. | `string` | `"StorageV2"` | no |
| account\_replication\_type | (Required) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS. | `string` | `"LRS"` | no |
| account\_tier | (Required) Defines the Tier to use for this storage account. Valid options are Standard and Premium. | `string` | `"Standard"` | no |
| azure\_files\_authentication | n/a | `map` | `{}` | no |
| backup | n/a | `any` | `null` | no |
| blob\_properties | n/a | `map` | `{}` | no |
| containers | n/a | `map` | `{}` | no |
| custom\_domain | n/a | `any` | `null` | no |
| data\_lake\_filesystems | n/a | `map` | `{}` | no |
| diagnostic\_profiles | n/a | `map` | `{}` | no |
| diagnostics | n/a | `map` | `{}` | no |
| enable\_https\_traffic\_only | (Optional) Boolean flag which forces HTTPS if enabled, see here for more information. Defaults to true. | `bool` | `true` | no |
| enable\_system\_msi | n/a | `map` | `{}` | no |
| existing | (Optional) Whether to reference an existing resource group. | `bool` | `false` | no |
| file\_shares | n/a | `map` | `{}` | no |
| identity | n/a | `any` | `null` | no |
| infrastructure\_encryption\_enabled | (Optional) Is infrastructure encryption enabled? Changing this forces a new resource to be created. Defaults to false. | `bool` | `null` | no |
| is\_hns\_enabled | (Optional) Is Hierarchical Namespace enabled? | `bool` | `false` | no |
| large\_file\_share\_enabled | (Optional) Is Large File Share Enabled? | `any` | `null` | no |
| location | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| management\_policies | n/a | `map` | `{}` | no |
| min\_tls\_version | (Optional) The minimum supported TLS version for the storage account. Possible values are TLS1\_0, TLS1\_1, and TLS1\_2. | `string` | `"TLS1_2"` | no |
| name | (Required) Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed. | `string` | n/a | yes |
| network | n/a | `map` | `{}` | no |
| nfsv3\_enabled | (Optional) Is NFSv3 protocol enabled? Changing this forces a new resource to be created. Defaults to false. | `bool` | `false` | no |
| private\_dns | n/a | `map` | `{}` | no |
| queue\_encryption\_key\_type | (Optional) The encryption type of the queue service. Possible values are Service and Account. | `string` | `null` | no |
| queue\_properties | n/a | `map` | `{}` | no |
| queues | n/a | `map` | `{}` | no |
| recovery\_vaults | n/a | `map` | `{}` | no |
| resource\_group\_name | (Required) The name of the resource group in which to create the storage account. Changing this forces a new resource to be created. | `string` | n/a | yes |
| routing | n/a | `map` | `{}` | no |
| static\_website | n/a | `map` | `{}` | no |
| table\_encryption\_key\_type | (Optional) The encryption type of the table service. Possible values are Service and Account. | `string` | `null` | no |
| tables | n/a | `map` | `{}` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| containers | The containers output objects as created by the container submodule. |
| data\_lake\_filesystems | The data lake filesystem output objects as created by the data lake filesystem submodule. |
| file\_share | The file shares output objects as created by the file shares submodule. |
| id | The ID of the Storage Account |
| name | The name of the Storage Account |
| primary\_access\_key | The endpoint URL for blob storage in the primary location. |
| primary\_blob\_connection\_string | n/a |
| primary\_blob\_endpoint | The endpoint URL for blob storage in the primary location. |
| primary\_connection\_string | n/a |
| primary\_web\_host | The hostname with port if applicable for web storage in the primary location. |
| queues | The queues output objects as created by the queues submodule. |
<!-- END_TF_DOCS -->