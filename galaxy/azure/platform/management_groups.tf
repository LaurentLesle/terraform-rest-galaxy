# ── Management Groups ──────────────────────────────────────────────────────────

# ── Tenant backfill ────────────────────────────────────────────────────────────
# On a brand-new tenant management groups are not yet enabled. Azure requires a
# one-time "backfill" to register all existing subscriptions under the new
# hierarchy root.  Set enable_tenant_backfill = true the *first* time you apply
# a config that creates management groups; revert to false (or omit) afterwards.
#
# The operation is idempotent — Azure returns status "Completed" or
# "NotStartedButGroupsExist" immediately if the backfill was already done.
#
# Flow: POST startTenantBackfill → poll tenantBackfillStatus until Completed
#       → management group resources created (depends_on the poll result)

variable "enable_tenant_backfill" {
  type        = bool
  default     = false
  description = <<-EOT
    Trigger a one-time Azure tenant backfill before creating management groups.
    Required on brand-new tenants where management groups have never been enabled.
    Set to true on the first apply, then revert to false (the operation is idempotent).
  EOT
}

resource "rest_operation" "start_tenant_backfill" {
  count  = var.enable_tenant_backfill ? 1 : 0
  path   = "/providers/Microsoft.Management/startTenantBackfill"
  method = "POST"

  query = {
    api-version = ["2023-04-01"]
  }

  output_attrs = toset(["tenantId", "status"])
}

resource "rest_operation" "wait_tenant_backfill" {
  count  = var.enable_tenant_backfill ? 1 : 0
  path   = "/providers/Microsoft.Management/tenantBackfillStatus"
  method = "GET"

  depends_on = [rest_operation.start_tenant_backfill]

  query = {
    api-version = ["2023-04-01"]
  }

  poll = {
    status_locator    = "body.status"
    default_delay_sec = 10
    status = {
      # NotStartedButGroupsExist = backfill not needed (groups already exist) — treat as success
      success = ["Completed", "NotStartedButGroupsExist"]
      pending = ["NotStarted", "Started"]
    }
  }

  output_attrs = toset(["tenantId", "status"])
}

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

  depends_on = [rest_operation.wait_tenant_backfill]

  management_group_id = try(each.value.management_group_id, each.key)
  display_name        = try(each.value.display_name, null)
  parent_id           = try(each.value.parent_id, null)
  check_existance     = var.check_existance

  auth_ref = try(each.value._tenant, null)
}
