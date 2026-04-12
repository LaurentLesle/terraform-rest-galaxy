# Source: azure-rest-api-specs
#   spec_path  : monitor/resource-manager/Microsoft.Insights/Insights
#   api_version: 2024-03-01-preview (latest with metricAlert_API.json; stable is 2018-03-01)
#   swagger    : metricAlert_API.json
#   stability  : preview

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

variable "metric_alert_name" {
  type        = string
  description = "The name of the metric alert rule."
}

variable "location" {
  type        = string
  default     = "global"
  description = "Resource location. Metric alerts are typically created in 'global'."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}

# ── Required alert properties ──────────────────────────────────────────────

variable "enabled" {
  type        = bool
  default     = true
  description = "The flag that indicates whether the metric alert is enabled."
}

variable "severity" {
  type        = number
  description = "Alert severity (0=critical, 1=error, 2=warning, 3=informational, 4=verbose)."

  validation {
    condition     = var.severity == null || (var.severity >= 0 && var.severity <= 4)
    error_message = "severity must be an integer between 0 and 4."
  }
}

variable "scopes" {
  type        = list(string)
  description = "The list of resource IDs that this metric alert is scoped to."
}

variable "evaluation_frequency" {
  type        = string
  description = "How often the metric alert is evaluated (ISO 8601 duration, e.g. PT1M, PT5M, PT15M, PT30M, PT1H)."

  validation {
    condition     = var.evaluation_frequency == null || can(regex("^PT?[0-9]+[YMWDHMS]$", var.evaluation_frequency))
    error_message = "evaluation_frequency must be a valid ISO 8601 duration (e.g. PT5M, PT1H)."
  }
}

variable "criteria" {
  type        = any
  description = "The rule criteria object. Must include odata.type. Use Microsoft.Azure.Monitor.SingleResourceMultipleMetricCriteria for single-resource static threshold alerts."
}

# ── Optional alert properties ──────────────────────────────────────────────

variable "description" {
  type        = string
  default     = null
  description = "The description of the metric alert that will be included in the alert email."
}

variable "window_size" {
  type        = string
  default     = null
  description = "The period of time (ISO 8601 duration) used to monitor alert activity based on the threshold (e.g. PT5M, PT1H)."

  validation {
    condition     = var.window_size == null || can(regex("^PT?[0-9]+[YMWDHMS]$", var.window_size))
    error_message = "window_size must be a valid ISO 8601 duration (e.g. PT5M, PT1H)."
  }
}

variable "target_resource_type" {
  type        = string
  default     = null
  description = "The resource type of the target resource. Mandatory if the scope contains a subscription, resource group, or more than one resource."
}

variable "target_resource_region" {
  type        = string
  default     = null
  description = "The region of the target resource(s). Mandatory if the scope contains a subscription, resource group, or more than one resource."
}

variable "auto_mitigate" {
  type        = bool
  default     = true
  description = "The flag that indicates whether the alert should be auto resolved. Default is true."
}

variable "actions" {
  type = list(object({
    action_group_id  = string
    webhook_properties = optional(map(string), null)
  }))
  default     = []
  description = "The list of action groups to invoke when the alert fires."
}

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

variable "custom_properties" {
  type        = map(string)
  default     = null
  description = "The dictionary of custom properties appended to the alert payload."
}

variable "action_properties" {
  type        = map(string)
  default     = null
  description = "The dictionary of action properties that customize the actions."
}

variable "resolve_configuration" {
  type = object({
    auto_resolved   = bool
    time_to_resolve = optional(string, null)
  })
  default     = null
  description = "Configuration for auto-resolving the alert."
}
