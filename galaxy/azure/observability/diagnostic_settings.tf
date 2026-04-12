# ── Diagnostic Settings ───────────────────────────────────────────────────────
# Diagnostic settings are scope-based (path is relative to a target resource).
# They are terminal — nothing in this config references their outputs, so they
# are NOT added to any ref-resolution context to avoid cycles.

variable "azure_diagnostic_settings" {
  type = map(object({
    resource_id                     = string
    diagnostic_setting_name         = optional(string, null)
    log_analytics_workspace_id      = optional(string, null)
    storage_account_id              = optional(string, null)
    event_hub_authorization_rule_id = optional(string, null)
    event_hub_name                  = optional(string, null)
    marketplace_partner_id          = optional(string, null)
    service_bus_rule_id             = optional(string, null)
    log_analytics_destination_type  = optional(string, null)
    logs = optional(list(object({
      category          = optional(string, null)
      category_group    = optional(string, null)
      enabled           = optional(bool, true)
      retention_enabled = optional(bool, null)
      retention_days    = optional(number, null)
    })), [])
    metrics = optional(list(object({
      category          = string
      enabled           = optional(bool, true)
      retention_enabled = optional(bool, null)
      retention_days    = optional(number, null)
    })), [])
  }))
  description = <<-EOT
    Map of Diagnostic Setting instances to create. Each map key acts as the for_each
    identifier and must be unique within this configuration.

    The resource_id is the full ARM ID of the target resource that the diagnostic
    setting will be attached to (e.g. a Log Analytics workspace, Application Insights
    component, or storage account).

    Example:
      azure_diagnostic_settings = {
        law-diag = {
          resource_id                = "/subscriptions/.../workspaces/my-law"
          log_analytics_workspace_id = "/subscriptions/.../workspaces/central-law"
          logs    = [{ category_group = "allLogs", enabled = true }]
          metrics = [{ category = "AllMetrics", enabled = true }]
        }
      }
  EOT
  default = {}
}

locals {
  # Diagnostic settings resolve at L3 — they can reference any prior resource output.
  # They are terminal (not added to context) to avoid cycles.
  azure_diagnostic_settings = provider::rest::resolve_map(
    local._ctx_l3,
    merge(try(local._yaml_raw.azure_diagnostic_settings, {}), var.azure_diagnostic_settings)
  )
}

module "azure_diagnostic_settings" {
  source   = "./modules/azure/diagnostic_setting"
  for_each = local.azure_diagnostic_settings

  depends_on = [
    module.azure_resource_groups,
    module.azure_log_analytics_workspaces,
    module.azure_application_insights,
    module.azure_resource_provider_registrations,
  ]

  resource_id                     = each.value.resource_id
  diagnostic_setting_name         = try(each.value.diagnostic_setting_name, each.key)
  log_analytics_workspace_id      = try(each.value.log_analytics_workspace_id, null)
  storage_account_id              = try(each.value.storage_account_id, null)
  event_hub_authorization_rule_id = try(each.value.event_hub_authorization_rule_id, null)
  event_hub_name                  = try(each.value.event_hub_name, null)
  marketplace_partner_id          = try(each.value.marketplace_partner_id, null)
  service_bus_rule_id             = try(each.value.service_bus_rule_id, null)
  log_analytics_destination_type  = try(each.value.log_analytics_destination_type, null)
  logs                            = try(each.value.logs, [])
  metrics                         = try(each.value.metrics, [])
  check_existance                 = var.check_existance
}
