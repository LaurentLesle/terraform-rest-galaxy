# ── Log Analytics Workspaces ───────────────────────────────────────────────────

variable "azure_log_analytics_workspaces" {
  type = map(object({
    subscription_id                                            = optional(string, null)
    resource_group_name                                        = string
    workspace_name                                             = optional(string, null)
    location                                                   = optional(string, null)
    sku_name                                                   = optional(string, "PerGB2018")
    sku_capacity_reservation_level                             = optional(number, null)
    retention_in_days                                          = optional(number, null)
    daily_quota_gb                                             = optional(number, null)
    public_network_access_for_ingestion                        = optional(string, "Enabled")
    public_network_access_for_query                            = optional(string, "Enabled")
    force_cmk_for_query                                        = optional(bool, null)
    features_enable_data_export                                = optional(bool, null)
    features_immediate_purge_data_on_30_days                   = optional(bool, null)
    features_enable_log_access_using_only_resource_permissions = optional(bool, null)
    features_cluster_resource_id                               = optional(string, null)
    features_disable_local_auth                                = optional(bool, true)
    default_data_collection_rule_resource_id                   = optional(string, null)
    identity_type                                              = optional(string, null)
    identity_user_assigned_identity_ids                        = optional(list(string), null)
    replication_enabled                                        = optional(bool, null)
    replication_location                                       = optional(string, null)
    tags                                                       = optional(map(string), null)
  }))
  description = "Map of Log Analytics Workspace instances to create. Each map key acts as the for_each identifier and must be unique within this configuration. When location is omitted, var.default_location is used as the default."
  default     = {}
}

locals {
  azure_log_analytics_workspaces = provider::rest::resolve_map(
    local._ctx_l0b,
    merge(try(local._yaml_raw.azure_log_analytics_workspaces, {}), var.azure_log_analytics_workspaces)
  )
  _law_ctx = provider::rest::merge_with_outputs(local.azure_log_analytics_workspaces, module.azure_log_analytics_workspaces)
}

module "azure_log_analytics_workspaces" {
  source   = "./modules/azure/log_analytics_workspace"
  for_each = local.azure_log_analytics_workspaces

  depends_on = [module.azure_resource_groups, module.azure_resource_provider_registrations]

  subscription_id                                            = try(each.value.subscription_id, var.subscription_id)
  resource_group_name                                        = each.value.resource_group_name
  workspace_name                                             = try(each.value.workspace_name, each.key)
  location                                                   = try(each.value.location != null ? each.value.location : local.default_location, local.default_location)
  sku_name                                                   = try(each.value.sku_name, "PerGB2018")
  sku_capacity_reservation_level                             = try(each.value.sku_capacity_reservation_level, null)
  retention_in_days                                          = try(each.value.retention_in_days, null)
  daily_quota_gb                                             = try(each.value.daily_quota_gb, null)
  public_network_access_for_ingestion                        = try(each.value.public_network_access_for_ingestion, "Enabled")
  public_network_access_for_query                            = try(each.value.public_network_access_for_query, "Enabled")
  force_cmk_for_query                                        = try(each.value.force_cmk_for_query, null)
  features_enable_data_export                                = try(each.value.features_enable_data_export, null)
  features_immediate_purge_data_on_30_days                   = try(each.value.features_immediate_purge_data_on_30_days, null)
  features_enable_log_access_using_only_resource_permissions = try(each.value.features_enable_log_access_using_only_resource_permissions, null)
  features_cluster_resource_id                               = try(each.value.features_cluster_resource_id, null)
  features_disable_local_auth                                = try(each.value.features_disable_local_auth, true)
  default_data_collection_rule_resource_id                   = try(each.value.default_data_collection_rule_resource_id, null)
  identity_type                                              = try(each.value.identity_type, null)
  identity_user_assigned_identity_ids                        = try(each.value.identity_user_assigned_identity_ids, null)
  replication_enabled                                        = try(each.value.replication_enabled, null)
  replication_location                                       = try(each.value.replication_location, null)
  tags                                                       = try(each.value.tags, null)
  check_existance                                            = var.check_existance
}
