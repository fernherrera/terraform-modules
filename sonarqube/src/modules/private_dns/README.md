<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_private_dns_a_record.a_records](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_aaaa_record.aaaa_records](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_aaaa_record) | resource |
| [azurerm_private_dns_cname_record.cname_records](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_cname_record) | resource |
| [azurerm_private_dns_mx_record.mx_records](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_mx_record) | resource |
| [azurerm_private_dns_ptr_record.ptr_records](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_ptr_record) | resource |
| [azurerm_private_dns_srv_record.srv_records](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_srv_record) | resource |
| [azurerm_private_dns_txt_record.txt_records](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_txt_record) | resource |
| [azurerm_private_dns_zone.private_dns](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.vnet_links](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| location | The location/region to keep all your network resources. To get the list of all locations with table format from azure cli, run 'az account list-locations -o table' | `string` | n/a | yes |
| name | (Required) Specifies the name. Changing this forces a new resource to be created. | `string` | n/a | yes |
| records | Configuration object - DNS records. | `any` | n/a | yes |
| resource\_group\_name | A container that holds related resources for an Azure solution | `string` | n/a | yes |
| soa\_record | (Optional) An soa\_record block. Changing this forces a new resource to be created. | `any` | `null` | no |
| tags | (Optional) A mapping of tags to assign to the resource. | `map(string)` | `{}` | no |
| vnet\_links | Configuration object - Private DNS Zone Virtual Network Links. | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The Private DNS Zone ID. |
| max\_number\_of\_record\_sets | The maximum number of record sets that can be created in this Private DNS zone. |
| max\_number\_of\_virtual\_network\_links | The maximum number of virtual networks that can be linked to this Private DNS zone. |
| max\_number\_of\_virtual\_network\_links\_with\_registration | The maximum number of virtual networks that can be linked to this Private DNS zone with registration enabled. |
| number\_of\_record\_sets | The current number of record sets in this Private DNS zone. |
<!-- END_TF_DOCS -->