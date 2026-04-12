# ── Data Collection Rules ──────────────────────────────────────────────────────

variable "azure_data_collection_rules" {
  type = map(object({
    subscription_id             = optional(string, null)
    resource_group_name         = string
    data_collection_rule_name   = optional(string, null)
    location                    = optional(string, null)
    description                 = optional(string, null)
    kind                        = optional(string, null)
    data_collection_endpoint_id = optional(string, null)
    stream_declarations         = optional(map(any), null)
    data_sources                = optional(any, null)
    direct_data_sources         = optional(any, null)
    destinations                = optional(any, null)
    references                  = optional(any, null)
    agent_settings              = optional(any, null)
    data_flows = optional(list(object({
      streams            = list(string)
      destinations       = list(string)
      transform_kql      = optional(string, null)
      output_stream      = optional(string, null)
      built_in_transform = optional(string, null)
    })), null)
    identity_type                       = optional(string, null)
    identity_user_assigned_identity_ids = optional(list(string), null)
    tags                                = optional(map(string), null)
  }))
  description = "Map of Data Collection Rule instances to create. Each map key acts as the for_each identifier and must be unique within this configuration. When location is omitted, var.default_location is used as the default."
  default     = {}
}

locals {
  azure_data_collection_rules = provider::rest::resolve_map(
    local._ctx_l2,
    merge(try(local._yaml_raw.azure_data_collection_rules, {}), var.azure_data_collection_rules)
  )
  _dcr_ctx = provider::rest::merge_with_outputs(local.azure_data_collection_rules, module.azure_data_collection_rules)
}

module "azure_data_collection_rules" {
  source   = "./modules/azure/data_collection_rule"
  for_each = local.azure_data_collection_rules

  depends_on = [
    module.azure_monitor_workspaces,
    module.azure_log_analytics_workspaces,
    module.azure_data_collection_endpoints,
  ]

  subscription_id                     = try(each.value.subscription_id, var.subscription_id)
  resource_group_name                 = each.value.resource_group_name
  data_collection_rule_name           = try(each.value.data_collection_rule_name, each.key)
  location                            = try(each.value.location != null ? each.value.location : local.default_location, local.default_location)
  description                         = try(each.value.description, null)
  kind                                = try(each.value.kind, null)
  data_collection_endpoint_id         = try(each.value.data_collection_endpoint_id, null)
  stream_declarations                 = try(each.value.stream_declarations, null)
  data_sources                        = try(each.value.data_sources, null)
  direct_data_sources                 = try(each.value.direct_data_sources, null)
  destinations                        = try(each.value.destinations, null)
  references                          = try(each.value.references, null)
  agent_settings                      = try(each.value.agent_settings, null)
  data_flows                          = try(each.value.data_flows, null)
  identity_type                       = try(each.value.identity_type, null)
  identity_user_assigned_identity_ids = try(each.value.identity_user_assigned_identity_ids, null)
  tags                                = try(each.value.tags, null)
  check_existance                     = var.check_existance
}
