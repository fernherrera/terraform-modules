<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_service_plan.asp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/service_plan) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_service\_environment\_id | (Optional) The ID of the App Service Environment to create this Service Plan in. | `any` | `null` | no |
| location | (Required) The Azure Region where the Service Plan should exist. Changing this forces a new AppService to be created. | `string` | n/a | yes |
| maximum\_elastic\_worker\_count | (Optional) The maximum number of workers to use in an Elastic SKU Plan. Cannot be set unless using an Elastic SKU. | `any` | n/a | yes |
| name | (Required) The name which should be used for this Service Plan. Changing this forces a new AppService to be created. | `string` | n/a | yes |
| os\_type | (Required) The O/S type for the App Services to be hosted in this plan. Possible values include Windows, Linux, and WindowsContainer. | `string` | `"Windows"` | no |
| per\_site\_scaling\_enabled | (Optional) Should Per Site Scaling be enabled. Defaults to false. | `bool` | `false` | no |
| resource\_group\_name | (Required) The name of the Resource Group where the AppService should exist. Changing this forces a new AppService to be created. | `string` | n/a | yes |
| sku\_name | (Required) The SKU for the plan. Possible values include B1, B2, B3, D1, F1, I1, I2, I3, I1v2, I2v2, I3v2, P1v2, P2v2, P3v2, P1v3, P2v3, P3v3, S1, S2, S3, SHARED, EP1, EP2, EP3, WS1, WS2, WS3, and Y1. | `string` | `"S1"` | no |
| tags | (Optional) A mapping of tags which should be assigned to the AppService. | `map(string)` | `{}` | no |
| worker\_count | (Optional) The number of Workers (instances) to be allocated. | `any` | n/a | yes |
| zone\_balancing\_enabled | (Optional) Should the Service Plan balance across Availability Zones in the region. Defaults to false. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| ase\_id | n/a |
| id | n/a |
| kind | n/a |
| reserved | n/a |
<!-- END_TF_DOCS -->