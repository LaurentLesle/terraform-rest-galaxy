# Source: azure-rest-api-specs
#   spec_path  : alertsmanagement/resource-manager/Microsoft.AlertsManagement/AlertProcessingRules
#   api_version: 2021-08-08
#   swagger    : AlertProcessingRules.json (stable)

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

variable "alert_processing_rule_name" {
  type        = string
  description = "The name of the alert processing rule."
}

variable "location" {
  type        = string
  description = "The geo-location where the resource lives."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}

# ── Required properties ────────────────────────────────────────────────────

variable "scopes" {
  type        = list(string)
  description = "Scopes on which the alert processing rule will apply."
}

variable "actions" {
  type = list(object({
    action_type      = string
    action_group_ids = optional(list(string), null)
  }))
  description = "Actions to be applied. action_type can be 'AddActionGroups', 'RemoveAllActionGroups', or 'CorrelateAlerts'."

  validation {
    condition = alltrue([
      for a in var.actions : a.action_type == null || contains(["AddActionGroups", "RemoveAllActionGroups", "CorrelateAlerts"], a.action_type)
    ])
    error_message = "action_type must be one of: AddActionGroups, RemoveAllActionGroups, CorrelateAlerts."
  }
}

# ── Optional properties ────────────────────────────────────────────────────

variable "conditions" {
  type = list(object({
    field    = string
    operator = string
    values   = list(string)
  }))
  default     = []
  description = "Conditions on which alerts will be filtered. field can be Severity, MonitorService, MonitorCondition, SignalType, TargetResourceType, TargetResource, TargetResourceGroup, AlertRuleId, AlertRuleName, Description, AlertContext."
}

variable "schedule" {
  type = object({
    effective_from  = optional(string, null)
    effective_until = optional(string, null)
    time_zone       = optional(string, null)
    recurrences = optional(list(object({
      recurrence_type = string
      start_time      = optional(string, null)
      end_time        = optional(string, null)
      days_of_week    = optional(list(string), null)
      days_of_month   = optional(list(number), null)
    })), null)
  })
  default     = null
  description = "Scheduling configuration for the alert processing rule."
}

variable "description" {
  type        = string
  default     = null
  description = "Description of the alert processing rule."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Indicates if the given alert processing rule is enabled or disabled."
}
