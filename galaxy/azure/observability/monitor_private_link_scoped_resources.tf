# ── Azure Monitor Private Link Scoped Resources ────────────────────────────────

variable "azure_monitor_private_link_scoped_resources" {
  type = map(object({
    subscription_id         = optional(string, null)
    resource_group_name     = string
    private_link_scope_name = string
    scoped_resource_name    = optional(string, null)
    linked_resource_id      = string
  }))
  description = "Map of Azure Monitor Private Link Scoped Resource associations to create. Each map key acts as the for_each identifier. Links an Azure Monitor resource (Log Analytics Workspace, Data Collection Endpoint, Azure Monitor Workspace) into a Private Link Scope."
  default     = {}
}

locals {
  azure_monitor_private_link_scoped_resources = provider::rest::resolve_map(
    local._ctx_l2,
    merge(try(local._yaml_raw.azure_monitor_private_link_scoped_resources, {}), var.azure_monitor_private_link_scoped_resources)
  )
  _amplssr_ctx = provider::rest::merge_with_outputs(local.azure_monitor_private_link_scoped_resources, module.azure_monitor_private_link_scoped_resources)
}

module "azure_monitor_private_link_scoped_resources" {
  source   = "./modules/azure/monitor_private_link_scoped_resource"
  for_each = local.azure_monitor_private_link_scoped_resources

  depends_on = [
    module.azure_monitor_private_link_scopes,
    module.azure_monitor_workspaces,
    module.azure_log_analytics_workspaces,
    module.azure_data_collection_endpoints,
  ]

  subscription_id         = try(each.value.subscription_id, var.subscription_id)
  resource_group_name     = each.value.resource_group_name
  private_link_scope_name = each.value.private_link_scope_name
  scoped_resource_name    = try(each.value.scoped_resource_name, null) != null ? each.value.scoped_resource_name : each.key
  linked_resource_id      = each.value.linked_resource_id
  check_existance         = var.check_existance
}
