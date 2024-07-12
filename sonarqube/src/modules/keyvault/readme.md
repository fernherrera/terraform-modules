<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| initial\_policy | ../keyvault_access_policies | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_key_vault.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_key_vault_secret.secret](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.secret_ignore_changes](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault.keyvault_e](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| azuread\_groups | n/a | `map` | `{}` | no |
| client\_config | Client configuration object (see module README.md). | `any` | n/a | yes |
| contact | (Optional) One or more contact block | `map` | `{}` | no |
| enable\_rbac\_authorization | (Optional) Boolean flag to specify whether Azure Key Vault uses Role Based Access Control (RBAC) for authorization of data actions. | `any` | `null` | no |
| enabled\_for\_deployment | (Optional) Boolean flag to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. | `any` | `null` | no |
| enabled\_for\_disk\_encryption | (Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. | `any` | `null` | no |
| enabled\_for\_template\_deployment | (Optional) Boolean flag to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. | `any` | `null` | no |
| existing | (Optional) Whether to reference an existing resource group. | `bool` | `false` | no |
| location | (Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created. | `string` | n/a | yes |
| managed\_identities | n/a | `map` | `{}` | no |
| name | (Required) Specifies the name of the Key Vault. Changing this forces a new resource to be created. The name must be globally unique. If the vault is in a recoverable state then the vault will need to be purged before reusing the name. | `string` | n/a | yes |
| network\_acls | (Optional) A network\_acls block. | `map` | `{}` | no |
| private\_dns | n/a | `map` | `{}` | no |
| public\_network\_access\_enabled | (Optional) Whether public network access is allowed for this Key Vault. Defaults to true. | `bool` | `true` | no |
| purge\_protection\_enabled | (Optional) Is Purge Protection enabled for this Key Vault? | `any` | `null` | no |
| resource\_group\_name | (Required) The name of the resource group in which to create the Key Vault. Changing this forces a new resource to be created. | `string` | n/a | yes |
| resource\_groups | n/a | `map` | `{}` | no |
| settings | (Required) Used to handle passthrough paramenters. | `any` | n/a | yes |
| sku\_name | (Required) The Name of the SKU used for this Key Vault. Possible values are standard and premium. | `string` | n/a | yes |
| soft\_delete\_retention\_days | (Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days. | `any` | `null` | no |
| tags | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| tenant\_id | (Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. | `string` | n/a | yes |
| vnets | n/a | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | n/a |
| name | n/a |
| rbac\_id | n/a |
| vault\_uri | n/a |
<!-- END_TF_DOCS -->