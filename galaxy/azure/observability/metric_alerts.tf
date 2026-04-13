# ── Metric Alerts ─────────────────────────────────────────────────────────────

variable "azure_metric_alerts" {
  type = map(object({
    subscription_id                     = optional(string, null)
    resource_group_name                 = string
    metric_alert_name                   = optional(string, null)
    location                            = optional(string, "global")
    enabled                             = optional(bool, true)
    severity                            = number
    scopes                              = list(string)
    evaluation_frequency                = string
    criteria                            = any
    description                         = optional(string, null)
    window_size                         = optional(string, null)
    target_resource_type                = optional(string, null)
    target_resource_region              = optional(string, null)
    auto_mitigate                       = optional(bool, true)
    identity_type                       = optional(string, null)
    identity_user_assigned_identity_ids = optional(list(string), null)
    custom_properties                   = optional(map(string), null)
    action_properties                   = optional(map(string), null)
    resolve_configuration = optional(object({
      auto_resolved   = bool
      time_to_resolve = optional(string, null)
    }), null)
    actions = optional(list(object({
      action_group_id    = string
      webhook_properties = optional(map(string), null)
    })), [])
    tags = optional(map(string), null)
  }))
  description = <<-EOT
    Map of Metric Alert instances to create. Each map key acts as the for_each
    identifier and must be unique within this configuration.

    Example:
      azure_metric_alerts = {
        high-cpu = {
          resource_group_name  = "rg-observability"
          severity             = 2
          scopes               = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
          evaluation_frequency = "PT5M"
          criteria = {
            "odata.type"     = "Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria"
            allOf = [{ name = "cpu", metricName = "Percentage CPU", operator = "GreaterThan", threshold = 90, timeAggregation = "Average", criterionType = "StaticThresholdCriterion" }]
          }
        }
      }
  EOT
  default     = {}
}

locals {
  azure_metric_alerts = provider::rest::resolve_map(
    local._ctx_l2,
    merge(try(local._yaml_raw.azure_metric_alerts, {}), var.azure_metric_alerts)
  )
  _ma_ctx = provider::rest::merge_with_outputs(local.azure_metric_alerts, module.azure_metric_alerts)
}

module "azure_metric_alerts" {
  source   = "./modules/azure/metric_alert"
  for_each = local.azure_metric_alerts

  depends_on = [module.azure_resource_groups, module.azure_action_groups, module.azure_resource_provider_registrations]

  subscription_id                     = try(each.value.subscription_id, var.subscription_id)
  resource_group_name                 = each.value.resource_group_name
  metric_alert_name                   = try(each.value.metric_alert_name, each.key)
  location                            = try(each.value.location, "global")
  enabled                             = try(each.value.enabled, true)
  severity                            = each.value.severity
  scopes                              = each.value.scopes
  evaluation_frequency                = each.value.evaluation_frequency
  criteria                            = each.value.criteria
  description                         = try(each.value.description, null)
  window_size                         = try(each.value.window_size, null)
  target_resource_type                = try(each.value.target_resource_type, null)
  target_resource_region              = try(each.value.target_resource_region, null)
  auto_mitigate                       = try(each.value.auto_mitigate, true)
  identity_type                       = try(each.value.identity_type, null)
  identity_user_assigned_identity_ids = try(each.value.identity_user_assigned_identity_ids, null)
  custom_properties                   = try(each.value.custom_properties, null)
  action_properties                   = try(each.value.action_properties, null)
  resolve_configuration               = try(each.value.resolve_configuration, null)
  actions                             = try(each.value.actions, [])
  tags                                = try(each.value.tags, null)
  check_existance                     = var.check_existance
}
