# ── Policy Definitions (Custom) ────────────────────────────────────────────────

variable "azure_policy_definitions" {
  type = map(object({
    scope                  = string
    policy_definition_name = optional(string, null) # defaults to the map key
    policy_type            = optional(string, "Custom")
    mode                   = optional(string, "All")
    display_name           = string
    policy_rule            = any
    description            = optional(string, null)
    metadata               = optional(any, null)
    parameters             = optional(any, null)
    _tenant                = optional(string, null)
  }))
  description = <<-EOT
    Map of custom Azure Policy definitions. Each map key acts as the for_each
    identifier and is used as policy_definition_name when the field is omitted.

    scope must be a management group ID or subscription ID path:
      ref:azure_management_groups.mg_platform.id
      /subscriptions/<sub-id>

    Example:
      azure_policy_definitions = {
        require_env_tag = {
          scope        = ref:azure_management_groups.mg_root.id
          display_name = "Require environment tag on resources"
          mode         = "Indexed"
          metadata     = { category = "Tags" }
          policy_rule  = {
            if   = { field = "tags['environment']", exists = "false" }
            then = { effect = "Deny" }
          }
        }
      }
  EOT
  default     = {}
}

locals {
  azure_policy_definitions = provider::rest::resolve_map(
    local._ctx_l0b,
    merge(try(local._yaml_raw.azure_policy_definitions, {}), var.azure_policy_definitions)
  )
  _pd_ctx = provider::rest::merge_with_outputs(local.azure_policy_definitions, module.azure_policy_definitions)
}

module "azure_policy_definitions" {
  source   = "./modules/azure/policy_definition"
  for_each = local.azure_policy_definitions

  depends_on = [module.azure_management_groups]

  scope                  = each.value.scope
  policy_definition_name = try(each.value.policy_definition_name, each.key)
  policy_type            = try(each.value.policy_type, "Custom")
  mode                   = try(each.value.mode, "All")
  display_name           = each.value.display_name
  policy_rule            = each.value.policy_rule
  description            = try(each.value.description, null)
  metadata               = try(each.value.metadata, null)
  parameters             = try(each.value.parameters, null)
  check_existance        = var.check_existance

  auth_ref = try(each.value._tenant, null)
}
