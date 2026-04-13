# Source: azure-rest-api-specs
#   spec_path  : monitor/resource-manager/Microsoft.Insights/Insights
#   api_version: 2026-01-01
#   swagger    : activityLogAlerts_API.json

# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it."
}

# ── Scope ──────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

# ── Resource identity ──────────────────────────────────────────────────────

variable "activity_log_alert_name" {
  type        = string
  description = "The name of the Activity Log Alert rule."
}

variable "location" {
  type        = string
  default     = "global"
  description = "The location of the resource. Azure Activity Log Alert rules are supported on Global, West Europe and North Europe regions."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "The tags of the resource."
}

# ── Required properties ────────────────────────────────────────────────────

variable "scopes" {
  type        = list(string)
  description = "A list of resource IDs that will be used as prefixes. The alert will only apply to Activity Log events with resource IDs under one of these prefixes."
}

variable "condition" {
  type = object({
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
  description = "An Activity Log Alert rule condition that is met when all its member conditions are met."
}

variable "actions" {
  type = object({
    action_groups = optional(list(object({
      action_group_id    = string
      webhook_properties = optional(map(string), null)
    })), [])
  })
  description = "A list of Activity Log Alert rule actions."
}

# ── Optional properties ────────────────────────────────────────────────────

variable "enabled" {
  type        = bool
  default     = true
  description = "Indicates whether this Activity Log Alert rule is enabled."
}

variable "description" {
  type        = string
  default     = null
  description = "A description of this Activity Log Alert rule."
}

variable "tenant_scope" {
  type        = string
  default     = null
  description = "The tenant GUID. Must be provided for tenant-level and management group events rules."
}
