# ── Azure Monitor Workspaces ───────────────────────────────────────────────────

variable "azure_monitor_workspaces" {
  type = map(object({
    subscription_id        = optional(string, null)
    resource_group_name    = string
    monitor_workspace_name = optional(string, null)
    location               = optional(string, null)
    tags                   = optional(map(string), null)
  }))
  description = "Map of Azure Monitor Workspace instances to create. Each map key acts as the for_each identifier and must be unique within this configuration. When location is omitted, var.default_location is used as the default."
  default     = {}
}

locals {
  azure_monitor_workspaces = provider::rest::resolve_map(
    local._ctx_l0b,
    merge(try(local._yaml_raw.azure_monitor_workspaces, {}), var.azure_monitor_workspaces)
  )
  _amw_ctx = provider::rest::merge_with_outputs(local.azure_monitor_workspaces, module.azure_monitor_workspaces)
}

module "azure_monitor_workspaces" {
  source   = "./modules/azure/monitor_workspace"
  for_each = local.azure_monitor_workspaces

  depends_on = [module.azure_resource_groups, module.azure_resource_provider_registrations]

  subscription_id        = try(each.value.subscription_id, var.subscription_id)
  resource_group_name    = each.value.resource_group_name
  monitor_workspace_name = try(each.value.monitor_workspace_name, each.key)
  location               = try(each.value.location != null ? each.value.location : local.default_location, local.default_location)
  tags                   = try(each.value.tags, null)
  check_existance        = var.check_existance
}
