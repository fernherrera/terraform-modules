variable "vwan_hub_erc_gw" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    virtual_hub_name    = string
    scale_unit          = number
  }))
    default = {}
}