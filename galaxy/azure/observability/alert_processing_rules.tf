# ── Alert Processing Rules ────────────────────────────────────────────────────

variable "azure_alert_processing_rules" {
  type = map(object({
    subscription_id            = optional(string, null)
    resource_group_name        = string
    alert_processing_rule_name = optional(string, null)
    location                   = optional(string, null)
    scopes                     = list(string)
    actions = list(object({
      action_type      = string
      action_group_ids = optional(list(string), null)
    }))
    conditions = optional(list(object({
      field    = string
      operator = string
      values   = list(string)
    })), [])
    schedule = optional(object({
      effective_from  = optional(string, null)
      effective_until = optional(string, null)
      time_zone       = optional(string, null)
      recurrences = optional(list(object({
        recurrence_type = string
        start_time      = optional(string, null)
        end_time        = optional(string, null)
        days_of_week    = optional(list(string), null)
        days_of_month   = optional(list(number), null)
      })), null)
    }), null)
    description = optional(string, null)
    enabled     = optional(bool, true)
    tags        = optional(map(string), null)
  }))
  description = <<-EOT
    Map of Alert Processing Rule instances to create. Each map key acts as the for_each
    identifier and must be unique within this configuration. When location is omitted,
    var.default_location is used as the default.

    Example:
      azure_alert_processing_rules = {
        maintenance-window = {
          resource_group_name = "rg-observability"
          location            = "westeurope"
          scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
          actions             = [{ action_type = "RemoveAllActionGroups" }]
          schedule = {
            time_zone = "UTC"
            recurrences = [{ recurrence_type = "Weekly", days_of_week = ["Saturday", "Sunday"] }]
          }
        }
      }
  EOT
  default     = {}
}

locals {
  azure_alert_processing_rules = provider::rest::resolve_map(
    local._ctx_l2,
    merge(try(local._yaml_raw.azure_alert_processing_rules, {}), var.azure_alert_processing_rules)
  )
  _apr_ctx = provider::rest::merge_with_outputs(local.azure_alert_processing_rules, module.azure_alert_processing_rules)
}

module "azure_alert_processing_rules" {
  source   = "./modules/azure/alert_processing_rule"
  for_each = local.azure_alert_processing_rules

  depends_on = [module.azure_resource_groups, module.azure_action_groups, module.azure_resource_provider_registrations]

  subscription_id            = try(each.value.subscription_id, var.subscription_id)
  resource_group_name        = each.value.resource_group_name
  alert_processing_rule_name = try(each.value.alert_processing_rule_name, each.key)
  location                   = try(each.value.location != null ? each.value.location : local.default_location, local.default_location)
  scopes                     = each.value.scopes
  actions                    = each.value.actions
  conditions                 = try(each.value.conditions, [])
  schedule                   = try(each.value.schedule, null)
  description                = try(each.value.description, null)
  enabled                    = try(each.value.enabled, true)
  tags                       = try(each.value.tags, null)
  check_existance            = var.check_existance
}
