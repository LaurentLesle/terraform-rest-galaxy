# ── Action Groups ──────────────────────────────────────────────────────────────

variable "azure_action_groups" {
  type = map(object({
    subscription_id              = optional(string, null)
    resource_group_name          = string
    action_group_name            = optional(string, null)
    location                     = optional(string, "global")
    short_name                   = string
    enabled                      = optional(bool, true)
    tags                         = optional(map(string), null)
    email_receivers = optional(list(object({
      name                    = string
      email_address           = string
      use_common_alert_schema = optional(bool, true)
    })), [])
    sms_receivers = optional(list(object({
      name         = string
      country_code = string
      phone_number = string
    })), [])
    webhook_receivers = optional(list(object({
      name                    = string
      service_uri             = string
      use_common_alert_schema = optional(bool, true)
      use_aad_auth            = optional(bool, false)
      object_id               = optional(string, null)
      identifier_uri          = optional(string, null)
      tenant_id               = optional(string, null)
    })), [])
    itsm_receivers = optional(list(object({
      name                 = string
      workspace_id         = string
      connection_id        = string
      ticket_configuration = string
      region               = string
    })), [])
    azure_app_push_receivers = optional(list(object({
      name          = string
      email_address = string
    })), [])
    automation_runbook_receivers = optional(list(object({
      name                    = string
      automation_account_id   = string
      runbook_name            = string
      webhook_resource_id     = string
      is_global_runbook       = bool
      service_uri             = optional(string, null)
      use_common_alert_schema = optional(bool, true)
    })), [])
    voice_receivers = optional(list(object({
      name         = string
      country_code = string
      phone_number = string
    })), [])
    logic_app_receivers = optional(list(object({
      name                    = string
      resource_id             = string
      callback_url            = string
      use_common_alert_schema = optional(bool, true)
    })), [])
    azure_function_receivers = optional(list(object({
      name                     = string
      function_app_resource_id = string
      function_name            = string
      http_trigger_url         = string
      use_common_alert_schema  = optional(bool, true)
    })), [])
    arm_role_receivers = optional(list(object({
      name                    = string
      role_id                 = string
      use_common_alert_schema = optional(bool, true)
    })), [])
    event_hub_receivers = optional(list(object({
      name                    = string
      event_hub_namespace     = string
      event_hub_name          = string
      subscription_id         = string
      tenant_id               = optional(string, null)
      use_common_alert_schema = optional(bool, true)
    })), [])
  }))
  description = <<-EOT
    Map of Action Group instances to create. Each map key acts as the for_each
    identifier and must be unique within this configuration.

    Example:
      azure_action_groups = {
        ops-team = {
          resource_group_name = "rg-observability"
          short_name          = "ops"
          email_receivers = [
            { name = "ops-email", email_address = "ops@example.com" }
          ]
        }
      }
  EOT
  default = {}
}

locals {
  azure_action_groups = provider::rest::resolve_map(
    local._ctx_l0b,
    merge(try(local._yaml_raw.azure_action_groups, {}), var.azure_action_groups)
  )
  _ag_ctx = provider::rest::merge_with_outputs(local.azure_action_groups, module.azure_action_groups)
}

module "azure_action_groups" {
  source   = "./modules/azure/action_group"
  for_each = local.azure_action_groups

  depends_on = [module.azure_resource_groups, module.azure_resource_provider_registrations]

  subscription_id              = try(each.value.subscription_id, var.subscription_id)
  resource_group_name          = each.value.resource_group_name
  action_group_name            = try(each.value.action_group_name, each.key)
  location                     = try(each.value.location, "global")
  short_name                   = each.value.short_name
  enabled                      = try(each.value.enabled, true)
  tags                         = try(each.value.tags, null)
  email_receivers              = try(each.value.email_receivers, [])
  sms_receivers                = try(each.value.sms_receivers, [])
  webhook_receivers            = try(each.value.webhook_receivers, [])
  itsm_receivers               = try(each.value.itsm_receivers, [])
  azure_app_push_receivers     = try(each.value.azure_app_push_receivers, [])
  automation_runbook_receivers = try(each.value.automation_runbook_receivers, [])
  voice_receivers              = try(each.value.voice_receivers, [])
  logic_app_receivers          = try(each.value.logic_app_receivers, [])
  azure_function_receivers     = try(each.value.azure_function_receivers, [])
  arm_role_receivers           = try(each.value.arm_role_receivers, [])
  event_hub_receivers          = try(each.value.event_hub_receivers, [])
  check_existance              = var.check_existance
}
