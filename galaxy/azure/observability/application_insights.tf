# ── Application Insights ───────────────────────────────────────────────────────

variable "azure_application_insights" {
  type = map(object({
    subscription_id                     = optional(string, null)
    resource_group_name                 = string
    application_insights_name           = optional(string, null)
    location                            = optional(string, null)
    kind                                = optional(string, "web")
    application_type                    = optional(string, "web")
    workspace_resource_id               = optional(string, null)
    flow_type                           = optional(string, "Bluefield")
    request_source                      = optional(string, "rest")
    retention_in_days                   = optional(number, 90)
    sampling_percentage                 = optional(number, null)
    disable_ip_masking                  = optional(bool, false)
    immediate_purge_data_on30_days      = optional(bool, null)
    hockey_app_id                       = optional(string, null)
    public_network_access_for_ingestion = optional(string, "Enabled")
    public_network_access_for_query     = optional(string, "Enabled")
    ingestion_mode                      = optional(string, "LogAnalytics")
    disable_local_auth                  = optional(bool, true)
    force_customer_storage_for_profiler = optional(bool, false)
    etag                                = optional(string, null)
    tags                                = optional(map(string), null)
  }))
  description = <<-EOT
    Map of Application Insights component instances to create. Each map key acts as the
    for_each identifier and must be unique within this configuration. When location is
    omitted, var.default_location is used as the default.

    Example:
      azure_application_insights = {
        app-monitoring = {
          resource_group_name   = "rg-observability"
          workspace_resource_id = "/subscriptions/.../workspaces/my-law"
          application_type      = "web"
        }
      }
  EOT
  default = {}
}

locals {
  azure_application_insights = provider::rest::resolve_map(
    local._ctx_l1,
    merge(try(local._yaml_raw.azure_application_insights, {}), var.azure_application_insights)
  )
  _appi_ctx = provider::rest::merge_with_outputs(local.azure_application_insights, module.azure_application_insights)
}

module "azure_application_insights" {
  source   = "./modules/azure/application_insights"
  for_each = local.azure_application_insights

  depends_on = [module.azure_resource_groups, module.azure_log_analytics_workspaces, module.azure_resource_provider_registrations]

  subscription_id                     = try(each.value.subscription_id, var.subscription_id)
  resource_group_name                 = each.value.resource_group_name
  application_insights_name           = try(each.value.application_insights_name, each.key)
  location                            = try(each.value.location != null ? each.value.location : local.default_location, local.default_location)
  kind                                = try(each.value.kind, "web")
  application_type                    = try(each.value.application_type, "web")
  workspace_resource_id               = try(each.value.workspace_resource_id, null)
  flow_type                           = try(each.value.flow_type, "Bluefield")
  request_source                      = try(each.value.request_source, "rest")
  retention_in_days                   = try(each.value.retention_in_days, 90)
  sampling_percentage                 = try(each.value.sampling_percentage, null)
  disable_ip_masking                  = try(each.value.disable_ip_masking, false)
  immediate_purge_data_on30_days      = try(each.value.immediate_purge_data_on30_days, null)
  hockey_app_id                       = try(each.value.hockey_app_id, null)
  public_network_access_for_ingestion = try(each.value.public_network_access_for_ingestion, "Enabled")
  public_network_access_for_query     = try(each.value.public_network_access_for_query, "Enabled")
  ingestion_mode                      = try(each.value.ingestion_mode, "LogAnalytics")
  disable_local_auth                  = try(each.value.disable_local_auth, true)
  force_customer_storage_for_profiler = try(each.value.force_customer_storage_for_profiler, false)
  etag                                = try(each.value.etag, null)
  tags                                = try(each.value.tags, null)
  check_existance                     = var.check_existance
}
