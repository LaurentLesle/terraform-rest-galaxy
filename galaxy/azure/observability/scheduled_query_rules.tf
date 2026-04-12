# ── Scheduled Query Rules ─────────────────────────────────────────────────────

variable "azure_scheduled_query_rules" {
  type = map(object({
    subscription_id                           = optional(string, null)
    resource_group_name                       = string
    rule_name                                 = optional(string, null)
    location                                  = optional(string, null)
    kind                                      = optional(string, "LogAlert")
    identity_type                             = optional(string, null)
    identity_user_assigned_identity_ids       = optional(list(string), null)
    scopes                                    = list(string)
    criteria = object({
      all_of = list(object({
        query                 = optional(string, null)
        time_aggregation      = optional(string, null)
        metric_measure_column = optional(string, null)
        resource_id_column    = optional(string, null)
        operator              = optional(string, null)
        threshold             = optional(number, null)
        failing_periods = optional(object({
          number_of_evaluation_periods = number
          min_failing_periods_to_alert = number
        }), null)
        dimensions = optional(list(object({
          name     = string
          operator = string
          values   = list(string)
        })), null)
      }))
    })
    description                               = optional(string, null)
    display_name                              = optional(string, null)
    severity                                  = optional(number, null)
    enabled                                   = optional(bool, true)
    evaluation_frequency                      = optional(string, null)
    window_size                               = optional(string, null)
    override_query_time_range                 = optional(string, null)
    target_resource_types                     = optional(list(string), null)
    mute_actions_duration                     = optional(string, null)
    actions = optional(object({
      action_groups     = optional(list(string), [])
      custom_properties = optional(map(string), null)
      action_properties = optional(map(string), null)
    }), null)
    check_workspace_alerts_storage_configured = optional(bool, false)
    skip_query_validation                     = optional(bool, false)
    auto_mitigate                             = optional(bool, true)
    resolve_configuration = optional(object({
      auto_resolved   = optional(bool, null)
      time_to_resolve = optional(string, null)
    }), null)
    tags = optional(map(string), null)
  }))
  description = <<-EOT
    Map of Scheduled Query Rule instances to create. Each map key acts as the for_each
    identifier and must be unique within this configuration.

    Example:
      azure_scheduled_query_rules = {
        failed-requests = {
          resource_group_name  = "rg-observability"
          location             = "westeurope"
          scopes               = ["/subscriptions/.../workspaces/my-law"]
          severity             = 1
          evaluation_frequency = "PT15M"
          window_size          = "PT15M"
          criteria = {
            all_of = [{ query = "requests | where success == false", time_aggregation = "Count", operator = "GreaterThan", threshold = 5, failing_periods = { number_of_evaluation_periods = 1, min_failing_periods_to_alert = 1 } }]
          }
        }
      }
  EOT
  default = {}
}

locals {
  azure_scheduled_query_rules = provider::rest::resolve_map(
    local._ctx_l2,
    merge(try(local._yaml_raw.azure_scheduled_query_rules, {}), var.azure_scheduled_query_rules)
  )
  _sqr_ctx = provider::rest::merge_with_outputs(local.azure_scheduled_query_rules, module.azure_scheduled_query_rules)
}

module "azure_scheduled_query_rules" {
  source   = "./modules/azure/scheduled_query_rule"
  for_each = local.azure_scheduled_query_rules

  depends_on = [module.azure_resource_groups, module.azure_log_analytics_workspaces, module.azure_action_groups, module.azure_resource_provider_registrations]

  subscription_id                           = try(each.value.subscription_id, var.subscription_id)
  resource_group_name                       = each.value.resource_group_name
  rule_name                                 = try(each.value.rule_name, each.key)
  location                                  = try(each.value.location != null ? each.value.location : local.default_location, local.default_location)
  kind                                      = try(each.value.kind, "LogAlert")
  identity_type                             = try(each.value.identity_type, null)
  identity_user_assigned_identity_ids       = try(each.value.identity_user_assigned_identity_ids, null)
  scopes                                    = each.value.scopes
  criteria                                  = each.value.criteria
  description                               = try(each.value.description, null)
  display_name                              = try(each.value.display_name, null)
  severity                                  = try(each.value.severity, null)
  enabled                                   = try(each.value.enabled, true)
  evaluation_frequency                      = try(each.value.evaluation_frequency, null)
  window_size                               = try(each.value.window_size, null)
  override_query_time_range                 = try(each.value.override_query_time_range, null)
  target_resource_types                     = try(each.value.target_resource_types, null)
  mute_actions_duration                     = try(each.value.mute_actions_duration, null)
  actions                                   = try(each.value.actions, null)
  check_workspace_alerts_storage_configured = try(each.value.check_workspace_alerts_storage_configured, false)
  skip_query_validation                     = try(each.value.skip_query_validation, false)
  auto_mitigate                             = try(each.value.auto_mitigate, true)
  resolve_configuration                     = try(each.value.resolve_configuration, null)
  tags                                      = try(each.value.tags, null)
  check_existance                           = var.check_existance
}
