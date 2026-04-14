# ── Managed Grafana Instances ──────────────────────────────────────────────────

variable "azure_managed_grafanas" {
  type = map(object({
    subscription_id                     = optional(string, null)
    resource_group_name                 = string
    grafana_name                        = optional(string, null)
    location                            = optional(string, null)
    sku_name                            = optional(string, "Standard")
    identity_type                       = optional(string, null)
    identity_user_assigned_identity_ids = optional(list(string), null)
    public_network_access               = optional(string, "Enabled")
    zone_redundancy                     = optional(string, "Disabled")
    api_key                             = optional(string, "Disabled")
    deterministic_outbound_ip           = optional(string, "Disabled")
    creator_can_admin                   = optional(string, null)
    grafana_major_version               = optional(string, null)
    azure_monitor_workspace_integrations = optional(list(object({
      azure_monitor_workspace_resource_id = string
    })), null)
    grafana_configurations_smtp = optional(object({
      enabled          = optional(bool, false)
      host             = optional(string, null)
      user             = optional(string, null)
      password         = optional(string, null)
      from_address     = optional(string, null)
      from_name        = optional(string, null)
      start_tls_policy = optional(string, null)
      skip_verify      = optional(bool, null)
    }), null)
    grafana_configurations_snapshots_external_enabled = optional(bool, null)
    grafana_configurations_users_viewers_can_edit     = optional(bool, null)
    grafana_configurations_users_editors_can_admin    = optional(bool, null)
    enterprise_marketplace_plan_id                    = optional(string, null)
    enterprise_marketplace_auto_renew                 = optional(string, null)
    grafana_plugins                                   = optional(map(any), null)
    tags                                              = optional(map(string), null)
  }))
  description = "Map of Managed Grafana instances to create. Each map key acts as the for_each identifier and must be unique within this configuration. When location is omitted, var.default_location is used as the default."
  default     = {}
}

locals {
  azure_managed_grafanas = provider::rest::resolve_map(
    local._ctx_l1,
    merge(try(local._yaml_raw.azure_managed_grafanas, {}), var.azure_managed_grafanas)
  )
  _grafana_ctx = provider::rest::merge_with_outputs(local.azure_managed_grafanas, module.azure_managed_grafanas)
}

module "azure_managed_grafanas" {
  source   = "./modules/azure/managed_grafana"
  for_each = local.azure_managed_grafanas

  depends_on = [module.azure_resource_groups, module.azure_user_assigned_identities, module.azure_monitor_workspaces]

  subscription_id                                   = try(each.value.subscription_id, var.subscription_id)
  resource_group_name                               = each.value.resource_group_name
  grafana_name                                      = try(each.value.grafana_name, each.key)
  location                                          = try(each.value.location != null ? each.value.location : local.default_location, local.default_location)
  sku_name                                          = try(each.value.sku_name, "Standard")
  identity_type                                     = try(each.value.identity_type, null)
  identity_user_assigned_identity_ids               = try(each.value.identity_user_assigned_identity_ids, null)
  public_network_access                             = try(each.value.public_network_access, "Enabled")
  zone_redundancy                                   = try(each.value.zone_redundancy, "Disabled")
  api_key                                           = try(each.value.api_key, "Disabled")
  deterministic_outbound_ip                         = try(each.value.deterministic_outbound_ip, "Disabled")
  creator_can_admin                                 = try(each.value.creator_can_admin, null)
  grafana_major_version                             = try(each.value.grafana_major_version, null)
  azure_monitor_workspace_integrations              = try(each.value.azure_monitor_workspace_integrations, null)
  grafana_configurations_smtp                       = try(each.value.grafana_configurations_smtp, null)
  grafana_configurations_snapshots_external_enabled = try(each.value.grafana_configurations_snapshots_external_enabled, null)
  grafana_configurations_users_viewers_can_edit     = try(each.value.grafana_configurations_users_viewers_can_edit, null)
  grafana_configurations_users_editors_can_admin    = try(each.value.grafana_configurations_users_editors_can_admin, null)
  enterprise_marketplace_plan_id                    = try(each.value.enterprise_marketplace_plan_id, null)
  enterprise_marketplace_auto_renew                 = try(each.value.enterprise_marketplace_auto_renew, null)
  grafana_plugins                                   = try(each.value.grafana_plugins, null)
  tags                                              = try(each.value.tags, null)
  check_existance                                   = var.check_existance
}
