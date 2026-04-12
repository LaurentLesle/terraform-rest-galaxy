# ── Identity ──────────────────────────────────────────────────────────────────

variable "management_group_id" {
  type        = string
  description = <<-EOT
    The management group ID (last segment of the ARM path, e.g. 'mg-platform').
    Must be unique within the tenant. Immutable after creation — changes force
    a destroy+create.
  EOT
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "display_name" {
  type        = string
  default     = null
  description = "The display name of the management group. Defaults to management_group_id when null."
}

variable "parent_id" {
  type        = string
  default     = null
  description = <<-EOT
    Full ARM resource ID of the parent management group or tenant root group.
    Example: /providers/Microsoft.Management/managementGroups/Tenant Root Group
    When null, the group is placed under the tenant root.

    IMPORTANT: Management groups are wired at galaxy layer L0 — before any other
    resource output is available. Do NOT use ref:azure_management_groups.* here;
    those IDs are not yet resolved at that layer. Use explicit static ARM paths:
      /providers/Microsoft.Management/managementGroups/{management_group_id}
  EOT
}

# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows."
}

variable "auth_ref" {
  type        = string
  default     = null
  description = "Reference to a named_auth entry in the provider for cross-tenant auth."
}
