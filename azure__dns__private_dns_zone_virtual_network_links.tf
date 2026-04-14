# ── Private DNS Zone Virtual Network Links ─────────────────────────────────────

variable "azure_private_dns_zone_virtual_network_links" {
  type = map(object({
    subscription_id           = optional(string, null)
    resource_group_name       = string
    private_dns_zone_name     = string
    virtual_network_link_name = optional(string, null)
    virtual_network_id        = string
    registration_enabled      = optional(bool, false)
    resolution_policy         = optional(string, null)
    tags                      = optional(map(string), null)
  }))
  description = "Map of Private DNS Zone Virtual Network Link instances to create. Each map key acts as the for_each identifier and must be unique within this configuration. Links a virtual network to a private DNS zone for private name resolution."
  default     = {}
}

locals {
  azure_private_dns_zone_virtual_network_links = provider::rest::resolve_map(
    local._ctx_l2,
    merge(try(local._yaml_raw.azure_private_dns_zone_virtual_network_links, {}), var.azure_private_dns_zone_virtual_network_links)
  )
  _pdzvnl_ctx = provider::rest::merge_with_outputs(local.azure_private_dns_zone_virtual_network_links, module.azure_private_dns_zone_virtual_network_links)
}

module "azure_private_dns_zone_virtual_network_links" {
  source   = "./modules/azure/private_dns_zone_virtual_network_link"
  for_each = local.azure_private_dns_zone_virtual_network_links

  depends_on = [module.azure_private_dns_zones, module.azure_virtual_networks]

  subscription_id           = try(each.value.subscription_id, var.subscription_id)
  resource_group_name       = each.value.resource_group_name
  private_dns_zone_name     = each.value.private_dns_zone_name
  virtual_network_link_name = try(each.value.virtual_network_link_name, null) != null ? each.value.virtual_network_link_name : each.key
  virtual_network_id        = each.value.virtual_network_id
  registration_enabled      = try(each.value.registration_enabled, false)
  resolution_policy         = try(each.value.resolution_policy, null)
  tags                      = try(each.value.tags, null)
  check_existance           = var.check_existance
}
