<!-- BEGIN_TF_DOCS -->


## Modules

| Name | Source | Version |
|------|--------|---------|
| azuread\_apps | ./access_policy | n/a |
| azuread\_group | ./access_policy | n/a |
| azuread\_service\_principals | ./access_policy | n/a |
| diagnostic\_storage\_accounts | ./access_policy | n/a |
| logged\_in\_aad\_app | ./access_policy | n/a |
| logged\_in\_user | ./access_policy | n/a |
| managed\_identity | ./access_policy | n/a |
| mssql\_managed\_instance | ./access_policy | n/a |
| mssql\_managed\_instances\_secondary | ./access_policy | n/a |
| object\_id | ./access_policy | n/a |
| storage\_accounts | ./access_policy | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| access\_policies | n/a | `any` | n/a | yes |
| azuread\_apps | n/a | `map` | `{}` | no |
| azuread\_groups | n/a | `map` | `{}` | no |
| client\_config | Client configuration object (see module README.md). | `any` | n/a | yes |
| keyvault\_id | n/a | `any` | `null` | no |
| keyvault\_key | n/a | `any` | `null` | no |
| keyvaults | n/a | `map` | `{}` | no |
| resources | n/a | `map` | `{}` | no |
<!-- END_TF_DOCS -->