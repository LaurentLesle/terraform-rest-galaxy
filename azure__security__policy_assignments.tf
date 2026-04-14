# ── Policy Assignments ─────────────────────────────────────────────────────────

variable "azure_policy_assignments" {
  type = map(object({
    scope                     = string
    assignment_name           = optional(string, null) # defaults to the map key
    policy_definition_id      = string
    display_name              = optional(string, null)
    description               = optional(string, null)
    enforcement_mode          = optional(string, "Default")
    parameters                = optional(any, null)
    not_scopes                = optional(list(string), [])
    metadata                  = optional(any, null)
    identity_type             = optional(string, "None")
    identity_user_assigned_id = optional(string, null)
    location                  = optional(string, null)
    non_compliance_messages = optional(list(object({
      message                        = string
      policy_definition_reference_id = optional(string, null)
    })), [])
    _tenant = optional(string, null)
  }))
  description = <<-EOT
    Map of policy assignments. Each map key acts as the for_each identifier
    and is used as assignment_name when the field is omitted.

    policy_definition_id can reference:
      - A custom policy:   ref:azure_policy_definitions.<key>.id
      - A custom initiative: ref:azure_policy_set_definitions.<key>.id
      - A built-in policy via externals: ref:externals.policy_definitions.<key>.id
      - A built-in initiative via externals: ref:externals.policy_set_definitions.<key>.id
      - An inline ARM ID: /providers/Microsoft.Authorization/policyDefinitions/{guid}

    Example:
      azure_policy_assignments = {
        lz_require_env_tag:
          scope:               ref:azure_management_groups.mg_landing_zones.id
          policy_definition_id: ref:azure_policy_definitions.require_env_tag.id
          display_name: "Require environment tag on LZ resources"
          enforcement_mode: Default

        lz_deny_public_ip:
          scope:               ref:azure_management_groups.mg_landing_zones.id
          policy_definition_id: ref:externals.policy_definitions.deny_public_ip.id
          display_name: "Deny public IP in landing zones"
          enforcement_mode: Default

        lz_cis_benchmark:
          scope:               ref:azure_management_groups.mg_landing_zones.id
          policy_definition_id: ref:externals.policy_set_definitions.cis_benchmark.id
          display_name: "CIS Microsoft Azure Foundations Benchmark"
          enforcement_mode: DoNotEnforce
  EOT
  default     = {}
}

locals {
  azure_policy_assignments = provider::rest::resolve_map(
    local._ctx_l2,
    merge(try(local._yaml_raw.azure_policy_assignments, {}), var.azure_policy_assignments)
  )
  _pa_ctx = provider::rest::merge_with_outputs(local.azure_policy_assignments, module.azure_policy_assignments)
}

module "azure_policy_assignments" {
  source   = "./modules/azure/policy_assignment"
  for_each = local.azure_policy_assignments

  depends_on = [module.azure_management_groups, module.azure_policy_definitions, module.azure_policy_set_definitions]

  scope                     = each.value.scope
  assignment_name           = try(each.value.assignment_name, each.key)
  policy_definition_id      = each.value.policy_definition_id
  display_name              = try(each.value.display_name, null)
  description               = try(each.value.description, null)
  enforcement_mode          = try(each.value.enforcement_mode, "Default")
  parameters                = try(each.value.parameters, null)
  not_scopes                = try(each.value.not_scopes, [])
  metadata                  = try(each.value.metadata, null)
  identity_type             = try(each.value.identity_type, "None")
  identity_user_assigned_id = try(each.value.identity_user_assigned_id, null)
  location                  = try(each.value.location, null)
  non_compliance_messages   = try(each.value.non_compliance_messages, [])
  check_existance           = var.check_existance

  auth_ref = try(each.value._tenant, null)
}
