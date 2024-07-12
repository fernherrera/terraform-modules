<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_private_endpoint.pep](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_resource_group.rgrp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create\_resource\_group | Whether to create resource group and use it for all networking resources | `bool` | `false` | no |
| custom\_network\_interface\_name | (Optional) The custom name of the network interface attached to the private endpoint. | `any` | `null` | no |
| ip\_configuration | (Optional) One or more ip\_configuration blocks. This allows a static IP address to be set for this Private Endpoint, otherwise an address is dynamically allocated from the Subnet. | `list` | `[]` | no |
| location | The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table' | `string` | `""` | no |
| name | (Required) Specifies the name. Changing this forces a new resource to be created. | `string` | n/a | yes |
| private\_dns\_zone\_group | (Optional) A private\_dns\_zone\_group block. | `map` | `{}` | no |
| private\_service\_connection | (Required) A private\_service\_connection block. | `any` | n/a | yes |
| resource\_group\_name | A container that holds related resources for an Azure solution | `string` | `""` | no |
| subnet\_id | (Required) The ID of the Subnet from which Private IP Addresses will be allocated for this Private Endpoint. | `any` | n/a | yes |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |
<!-- END_TF_DOCS -->