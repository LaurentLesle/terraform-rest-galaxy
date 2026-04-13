# ── Azure Monitor Private Link Scopes (AMPLS) ──────────────────────────────────

variable "azure_monitor_private_link_scopes" {
  type = map(object({
    subscription_id       = optional(string, null)
    resource_group_name   = string
    scope_name            = optional(string, null)
    location              = optional(string, null)
    ingestion_access_mode = optional(string, "PrivateOnly")
    query_access_mode     = optional(string, "PrivateOnly")
    access_mode_exclusions = optional(list(object({
      privateEndpointConnectionName = string
      privateEndpointResourceId     = string
      ingestionAccessMode           = optional(string, null)
      queryAccessMode               = optional(string, null)
    })), [])
    tags = optional(map(string), null)
  }))
  description = "Map of Azure Monitor Private Link Scope instances to create. Each map key acts as the for_each identifier and must be unique within this configuration. When location is omitted, var.default_location is used as the default."
  default     = {}
}

locals {
  azure_monitor_private_link_scopes = provider::rest::resolve_map(
    local._ctx_l0b,
    merge(try(local._yaml_raw.azure_monitor_private_link_scopes, {}), var.azure_monitor_private_link_scopes)
  )
  _ampls_ctx = provider::rest::merge_with_outputs(local.azure_monitor_private_link_scopes, module.azure_monitor_private_link_scopes)
}

module "azure_monitor_private_link_scopes" {
  source   = "./modules/azure/monitor_private_link_scope"
  for_each = local.azure_monitor_private_link_scopes

  depends_on = [module.azure_resource_groups, module.azure_resource_provider_registrations]

  subscription_id        = try(each.value.subscription_id, var.subscription_id)
  resource_group_name    = each.value.resource_group_name
  scope_name             = try(each.value.scope_name, null) != null ? each.value.scope_name : each.key
  location               = try(each.value.location != null ? each.value.location : local.default_location, local.default_location)
  ingestion_access_mode  = try(each.value.ingestion_access_mode, "PrivateOnly")
  query_access_mode      = try(each.value.query_access_mode, "PrivateOnly")
  access_mode_exclusions = try(each.value.access_mode_exclusions, [])
  tags                   = try(each.value.tags, null)
  check_existance        = var.check_existance
}
