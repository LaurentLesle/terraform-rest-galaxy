# ── Management Groups ──────────────────────────────────────────────────────────

variable "azure_management_groups" {
  type = map(object({
    management_group_id = optional(string, null) # defaults to the map key
    display_name        = optional(string, null)
    parent_id           = optional(string, null)
    _tenant             = optional(string, null)
  }))
  description = <<-EOT
    Map of management groups to create or manage. Each map key acts as the
    for_each identifier and is used as management_group_id when the field is omitted.

    Example:
      azure_management_groups = {
        mg_platform = {
          display_name = "Platform"
          parent_id    = ref:azure_management_groups.mg_root.id
        }
        mg_landing_zones = {
          display_name = "Landing Zones"
          parent_id    = ref:azure_management_groups.mg_root.id
        }
        mg_corp = {
          display_name = "Corp"
          parent_id    = ref:azure_management_groups.mg_landing_zones.id
        }
      }
  EOT
  default     = {}
}

locals {
  azure_management_groups = provider::rest::resolve_map(
    local._ctx_l0,
    merge(try(local._yaml_raw.azure_management_groups, {}), var.azure_management_groups)
  )
  _mg_ctx = provider::rest::merge_with_outputs(local.azure_management_groups, module.azure_management_groups)
}

module "azure_management_groups" {
  source   = "./modules/azure/management_group"
  for_each = local.azure_management_groups

  management_group_id = try(each.value.management_group_id, each.key)
  display_name        = try(each.value.display_name, null)
  parent_id           = try(each.value.parent_id, null)
  check_existance     = var.check_existance

  auth_ref = try(each.value._tenant, null)
}
