<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |
| time | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_user_assigned_identity.msi](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [time_sleep.propagate_to_azuread](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| location | (Required) The Azure Region where the User Assigned Identity should exist. | `any` | n/a | yes |
| name | (Required) Specifies the name of this User Assigned Identity. | `any` | n/a | yes |
| resource\_group\_name | (Required) Specifies the name of the Resource Group within which this User Assigned Identity should exist. | `any` | n/a | yes |
| tags | (Optional) A mapping of tags which should be assigned to the User Assigned Identity. | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| client\_id | The ID of the app associated with the Identity. |
| id | The ID of the User Assigned Identity. |
| principal\_id | The ID of the Service Principal object associated with the created Identity. |
| tenant\_id | The ID of the Tenant which the Identity belongs to. |
<!-- END_TF_DOCS -->