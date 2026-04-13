# Source: azure-rest-api-specs
#   spec_path  : monitor/resource-manager/Microsoft.Insights/Insights
#   api_version: 2021-05-01-preview
#   swagger    : diagnosticsSettings_API.json

# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it."
}

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID. Used to verify resource provider registration."
}

# ── Path parameters ────────────────────────────────────────────────────────

variable "resource_id" {
  type        = string
  description = "The full ARM resource ID of the target resource (e.g. a storage account, key vault, or log analytics workspace). The diagnostic setting will be created under this resource."
}

variable "diagnostic_setting_name" {
  type        = string
  description = "The name of the diagnostic setting."

  validation {
    condition     = var.diagnostic_setting_name == null || can(regex("^[a-zA-Z0-9][a-zA-Z0-9_.-]{0,259}$", var.diagnostic_setting_name))
    error_message = "diagnostic_setting_name must start with alphanumeric and contain only alphanumeric, underscores, hyphens, or dots (max 260 chars)."
  }
}

# ── Destination settings ───────────────────────────────────────────────────

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "The full ARM resource ID of the Log Analytics workspace to which Diagnostic Logs will be sent."
}

variable "storage_account_id" {
  type        = string
  default     = null
  description = "The resource ID of the storage account to which Diagnostic Logs will be sent."
}

variable "event_hub_authorization_rule_id" {
  type        = string
  default     = null
  description = "The resource ID for the event hub authorization rule."
}

variable "event_hub_name" {
  type        = string
  default     = null
  description = "The name of the event hub. If none is specified, the default event hub will be selected."
}

variable "marketplace_partner_id" {
  type        = string
  default     = null
  description = "The full ARM resource ID of the Marketplace resource to which Diagnostic Logs will be sent."
}

variable "service_bus_rule_id" {
  type        = string
  default     = null
  description = "The service bus rule ID of the diagnostic setting (maintained for backwards compatibility)."
}

variable "log_analytics_destination_type" {
  type        = string
  default     = null
  description = "A string indicating whether the export to Log Analytics should use the default destination type (AzureDiagnostics) or a dedicated type. Possible values: Dedicated, null (default)."

  validation {
    condition     = var.log_analytics_destination_type == null || contains(["Dedicated", "AzureDiagnostics"], var.log_analytics_destination_type)
    error_message = "log_analytics_destination_type must be null, 'Dedicated', or 'AzureDiagnostics'."
  }
}

# ── Log and Metric settings ────────────────────────────────────────────────

variable "logs" {
  type = list(object({
    category          = optional(string, null)
    category_group    = optional(string, null)
    enabled           = optional(bool, true)
    retention_enabled = optional(bool, null)
    retention_days    = optional(number, null)
  }))
  default     = []
  description = "List of log settings. Each entry specifies a log category or category group to capture."
}

variable "metrics" {
  type = list(object({
    category          = string
    enabled           = optional(bool, true)
    retention_enabled = optional(bool, null)
    retention_days    = optional(number, null)
  }))
  default     = []
  description = "List of metric settings. Each entry specifies a metric category to capture."
}
