<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_app_service_certificate.appcert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_certificate) | resource |
| [azurerm_app_service_certificate_binding.cb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_certificate_binding) | resource |
| [azurerm_app_service_custom_hostname_binding.app_service](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_custom_hostname_binding) | resource |
| [azurerm_app_service_source_control.scm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/app_service_source_control) | resource |
| [azurerm_linux_web_app.web_app](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_web_app) | resource |
| [azurerm_key_vault_certificate.cert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault_certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_settings | (Optional) A map of key-value pairs of App Settings. | `map(string)` | `{}` | no |
| application\_insight | (Optional) An Application Insights block | `any` | `null` | no |
| auth\_settings | (Optional) An auth\_settings block. | `map` | `{}` | no |
| auth\_settings\_v2 | (Optional) An auth\_settings\_v2 block. | `map` | `{}` | no |
| backup | (Optional) A backup block. | `map` | `{}` | no |
| certificates | (Optional) One or more certificates block. | `map` | `{}` | no |
| client\_affinity\_enabled | (Optional) Should Client Affinity be enabled? | `bool` | `false` | no |
| client\_certificate\_enabled | (Optional) Should Client Certificates be enabled? | `bool` | `false` | no |
| client\_certificate\_exclusion\_paths | (Optional) Paths to exclude when using client certificates, separated by ; | `any` | `null` | no |
| client\_certificate\_mode | (Optional) The Client Certificate mode. Possible values are Required, Optional, and OptionalInteractiveUser. This property has no effect when client\_certificate\_enabled is false | `string` | `"Optional"` | no |
| connection\_strings | (Optional) One or more connection\_string blocks. | `map` | `{}` | no |
| custom\_hostname\_bindings | (Optional) One or more custom\_hostname\_bindings blocks. | `map` | `{}` | no |
| enabled | (Optional) Should the Linux Web App be enabled? Defaults to true. | `bool` | `true` | no |
| https\_only | (Optional) Should the Linux Web App require HTTPS connections. | `bool` | `false` | no |
| identity | (Optional) An identity block | `any` | `null` | no |
| key\_vault\_reference\_identity\_id | (Optional) The User Assigned Identity ID used for accessing KeyVault secrets. The identity must be assigned to the application in the identity block. | `any` | n/a | yes |
| location | (Required) The Azure Region where the Linux Web App should exist. | `string` | n/a | yes |
| logs | (Optional) A logs block | `any` | `null` | no |
| name | (Required) The name which should be used for this Linux Web App. | `string` | n/a | yes |
| resource\_group\_name | (Required) The name of the Resource Group where the Linux Web App should exist. | `string` | n/a | yes |
| service\_plan\_id | (Required) The ID of the Service Plan that this Windows App Service will be created in. | `any` | n/a | yes |
| site\_config | (Required) A site\_config block. | `any` | n/a | yes |
| source\_control | n/a | `map` | `{}` | no |
| sticky\_settings | (Optional) A sticky\_settings block. | `any` | `null` | no |
| storage\_account | (Optional) One or more storage\_account blocks. | `map` | `{}` | no |
| tags | (Optional) A mapping of tags which should be assigned to the Linux Web App. | `map(string)` | `{}` | no |
| virtual\_network\_subnet\_id | (Optional) The subnet id which will be used by this Web App for regional virtual network integration. | `any` | `null` | no |
| zip\_deploy\_file | (Optional) The local path and filename of the Zip packaged application to deploy to this Linux Web App. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The ID of the Linux Web App. |
| outbound\_ip\_addresses | A comma separated list of outbound IP addresses |
| possible\_outbound\_ip\_addresses | A comma separated list of outbound IP addresses. not all of which are necessarily in use |
| site\_credential | The output of any site credentials |
| web\_app\_id | The ID of the App Service. |
| web\_app\_name | The name of the App Service. |
| web\_identity | The managed identity block from the Function app |
<!-- END_TF_DOCS -->