# ── Policy Set Definitions (Initiatives) ──────────────────────────────────────

variable "azure_policy_set_definitions" {
  type = map(object({
    scope                      = string
    policy_set_definition_name = optional(string, null) # defaults to the map key
    policy_type                = optional(string, "Custom")
    display_name               = string
    policy_definitions = optional(any, [])
    description = optional(string, null)
    metadata    = optional(any, null)
    parameters  = optional(any, null)
    policy_definition_groups = optional(list(object({
      name                = string
      display_name        = optional(string, null)
      description         = optional(string, null)
      additional_metadata = optional(any, null)
    })), [])
    _tenant = optional(string, null)
  }))
  description = <<-EOT
    Map of custom Azure Policy Set Definitions (Initiatives). Each map key acts
    as the for_each identifier and is used as policy_set_definition_name when
    the field is omitted.

    scope must be a management group ID path or subscription ID path.

    Example:
      azure_policy_set_definitions = {
        lz_baseline = {
          scope        = ref:azure_management_groups.mg_landing_zones.id
          display_name = "Landing Zone Baseline Initiative"
          metadata     = { category = "Landing Zone" }
          policy_definitions = [
            {
              policy_definition_id           = ref:azure_policy_definitions.require_env_tag.id
              policy_definition_reference_id = "require_env_tag"
            },
            {
              policy_definition_id           = ref:externals.policy_definitions.deny_public_ip.id
              policy_definition_reference_id = "deny_public_ip"
            }
          ]
        }
      }
  EOT
  default     = {}
}

locals {
  azure_policy_set_definitions = provider::rest::resolve_map(
    local._ctx_l1,
    merge(try(local._yaml_raw.azure_policy_set_definitions, {}), var.azure_policy_set_definitions)
  )
  _psd_ctx = provider::rest::merge_with_outputs(local.azure_policy_set_definitions, module.azure_policy_set_definitions)
}

module "azure_policy_set_definitions" {
  source   = "./modules/azure/policy_set_definition"
  for_each = local.azure_policy_set_definitions

  depends_on = [module.azure_management_groups, module.azure_policy_definitions]

  scope                      = each.value.scope
  policy_set_definition_name = try(each.value.policy_set_definition_name, each.key)
  policy_type                = try(each.value.policy_type, "Custom")
  display_name               = each.value.display_name
  policy_definitions         = each.value.policy_definitions
  description                = try(each.value.description, null)
  metadata                   = try(each.value.metadata, null)
  parameters                 = try(each.value.parameters, null)
  policy_definition_groups   = try(each.value.policy_definition_groups, [])
  check_existance            = var.check_existance

  auth_ref = try(each.value._tenant, null)
}
