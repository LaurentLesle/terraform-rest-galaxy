# ── Activity Log Alerts ───────────────────────────────────────────────────────

variable "azure_activity_log_alerts" {
  type = map(object({
    subscription_id         = optional(string, null)
    resource_group_name     = string
    activity_log_alert_name = optional(string, null)
    location                = optional(string, "global")
    scopes                  = list(string)
    condition = object({
      all_of = list(object({
        field        = optional(string, null)
        equals       = optional(string, null)
        contains_any = optional(list(string), null)
        any_of = optional(list(object({
          field  = optional(string, null)
          equals = optional(string, null)
        })), null)
      }))
    })
    actions = object({
      action_groups = optional(list(object({
        action_group_id    = string
        webhook_properties = optional(map(string), null)
      })), [])
    })
    enabled      = optional(bool, true)
    description  = optional(string, null)
    tenant_scope = optional(string, null)
    tags         = optional(map(string), null)
  }))
  description = <<-EOT
    Map of Activity Log Alert rule instances to create. Each map key acts as the for_each
    identifier and must be unique within this configuration.

    Example:
      azure_activity_log_alerts = {
        resource-deleted = {
          resource_group_name = "rg-observability"
          scopes              = ["/subscriptions/00000000-0000-0000-0000-000000000000"]
          condition = {
            all_of = [
              { field = "category", equals = "Administrative" },
              { field = "operationName", contains_any = ["delete"] }
            ]
          }
          actions = {
            action_groups = [{ action_group_id = "/subscriptions/.../actionGroups/ops" }]
          }
        }
      }
  EOT
  default = {}
}

locals {
  azure_activity_log_alerts = provider::rest::resolve_map(
    local._ctx_l2,
    merge(try(local._yaml_raw.azure_activity_log_alerts, {}), var.azure_activity_log_alerts)
  )
  _ala_ctx = provider::rest::merge_with_outputs(local.azure_activity_log_alerts, module.azure_activity_log_alerts)
}

module "azure_activity_log_alerts" {
  source   = "./modules/azure/activity_log_alert"
  for_each = local.azure_activity_log_alerts

  depends_on = [module.azure_resource_groups, module.azure_action_groups, module.azure_resource_provider_registrations]

  subscription_id         = try(each.value.subscription_id, var.subscription_id)
  resource_group_name     = each.value.resource_group_name
  activity_log_alert_name = try(each.value.activity_log_alert_name, each.key)
  location                = try(each.value.location, "global")
  scopes                  = each.value.scopes
  condition               = each.value.condition
  actions                 = each.value.actions
  enabled                 = try(each.value.enabled, true)
  description             = try(each.value.description, null)
  tenant_scope            = try(each.value.tenant_scope, null)
  tags                    = try(each.value.tags, null)
  check_existance         = var.check_existance
}
