# Source: azure-rest-api-specs
#   spec_path  : monitor/resource-manager/Microsoft.Insights/Insights
#   api_version: 2026-03-01
#   swagger    : scheduledQueryRule_API.json

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

variable "rule_name" {
  type        = string
  description = "The name of the scheduled query rule."
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

variable "kind" {
  type        = string
  default     = "LogAlert"
  description = "Indicates the type of scheduled query rule. Default is LogAlert."

  validation {
    condition     = var.kind == null || contains(["LogAlert", "SimpleLogAlert", "LogToMetric"], var.kind)
    error_message = "kind must be LogAlert, SimpleLogAlert, or LogToMetric."
  }
}

# ── Identity ───────────────────────────────────────────────────────────────

variable "identity_type" {
  type        = string
  default     = null
  description = "Type of managed service identity (SystemAssigned, UserAssigned, or None)."

  validation {
    condition     = var.identity_type == null || contains(["SystemAssigned", "UserAssigned", "None"], var.identity_type)
    error_message = "identity_type must be SystemAssigned, UserAssigned, or None."
  }
}

variable "identity_user_assigned_identity_ids" {
  type        = list(string)
  default     = null
  description = "List of user-assigned managed identity resource IDs."
}

# ── Required rule properties ───────────────────────────────────────────────

variable "scopes" {
  type        = list(string)
  description = "The list of resource IDs that this scheduled query rule is scoped to."
}

variable "criteria" {
  type = object({
    all_of = list(object({
      query                   = optional(string, null)
      time_aggregation        = optional(string, null)
      metric_measure_column   = optional(string, null)
      resource_id_column      = optional(string, null)
      operator                = optional(string, null)
      threshold               = optional(number, null)
      failing_periods = optional(object({
        number_of_evaluation_periods = number
        min_failing_periods_to_alert = number
      }), null)
      dimensions = optional(list(object({
        name     = string
        operator = string
        values   = list(string)
      })), null)
    }))
  })
  description = "The rule criteria defining the conditions of the scheduled query rule."
}

# ── Optional rule properties ───────────────────────────────────────────────

variable "description" {
  type        = string
  default     = null
  description = "The description of the scheduled query rule."
}

variable "display_name" {
  type        = string
  default     = null
  description = "The display name of the alert rule."
}

variable "severity" {
  type        = number
  default     = null
  description = "Alert severity (0=critical, 1=error, 2=warning, 3=informational, 4=verbose)."

  validation {
    condition     = var.severity == null || (var.severity >= 0 && var.severity <= 4)
    error_message = "severity must be between 0 and 4."
  }
}

variable "enabled" {
  type        = bool
  default     = true
  description = "The flag indicating whether this scheduled query rule is enabled."
}

variable "evaluation_frequency" {
  type        = string
  default     = null
  description = "How often the scheduled query rule is evaluated (ISO 8601 duration, e.g. PT5M, PT1H)."

  validation {
    condition     = var.evaluation_frequency == null || can(regex("^PT?[0-9]+[YMWDHMS]$", var.evaluation_frequency))
    error_message = "evaluation_frequency must be a valid ISO 8601 duration."
  }
}

variable "window_size" {
  type        = string
  default     = null
  description = "The period of time (ISO 8601 duration) on which the Alert query will be executed."

  validation {
    condition     = var.window_size == null || can(regex("^PT?[0-9]+[YMWDHMS]$", var.window_size))
    error_message = "window_size must be a valid ISO 8601 duration."
  }
}

variable "override_query_time_range" {
  type        = string
  default     = null
  description = "If specified, overrides the query time range (default is WindowSize*NumberOfEvaluationPeriods)."
}

variable "target_resource_types" {
  type        = list(string)
  default     = null
  description = "List of resource types of the target resource(s) on which the alert is created/updated."
}

variable "mute_actions_duration" {
  type        = string
  default     = null
  description = "Mute actions for the chosen period of time (ISO 8601 duration) after the alert is fired."
}

variable "actions" {
  type = object({
    action_groups     = optional(list(string), [])
    custom_properties = optional(map(string), null)
    action_properties = optional(map(string), null)
  })
  default     = null
  description = "Actions to invoke when the alert fires."
}

variable "check_workspace_alerts_storage_configured" {
  type        = bool
  default     = false
  description = "Whether this scheduled query rule should be stored in the customer's storage."
}

variable "skip_query_validation" {
  type        = bool
  default     = false
  description = "Whether the provided query should be validated or not."
}

variable "auto_mitigate" {
  type        = bool
  default     = true
  description = "Whether the alert should be automatically resolved. Default is true."
}

variable "resolve_configuration" {
  type = object({
    auto_resolved    = optional(bool, null)
    time_to_resolve  = optional(string, null)
  })
  default     = null
  description = "Configuration for automatically resolving the alert."
}
