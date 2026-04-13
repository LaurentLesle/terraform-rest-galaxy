variable "id_token" {
  type        = string
  sensitive   = true
  default     = null
  description = "GitHub Actions OIDC JWT. Required when access_token is not set."
}

variable "tenant_id" {
  type        = string
  default     = null
  description = "The Azure tenant ID."
}

variable "client_id" {
  type        = string
  default     = null
  description = "The Azure app registration client ID."
}

variable "access_token" {
  type        = string
  sensitive   = true
  default     = null
  description = "Direct Azure access token for local dev."
}

variable "resource_id" {
  type        = string
  description = "The full ARM resource ID of the target resource to attach the diagnostic setting to."
}

variable "diagnostic_setting_name" {
  type        = string
  description = "The name of the Diagnostic Setting."
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "The full ARM resource ID of the Log Analytics workspace to send logs to."
}

variable "log_analytics_destination_type" {
  type        = string
  default     = null
  description = "When set to Dedicated, logs sent to a Log Analytics workspace go into resource-specific tables. Allowed: AzureDiagnostics, Dedicated."
}

variable "logs" {
  type = list(object({
    category          = optional(string, null)
    category_group    = optional(string, null)
    enabled           = optional(bool, true)
    retention_enabled = optional(bool, null)
    retention_days    = optional(number, null)
  }))
  default     = []
  description = "List of log category or category group settings."
}

variable "metrics" {
  type = list(object({
    category          = string
    enabled           = optional(bool, true)
    retention_enabled = optional(bool, null)
    retention_days    = optional(number, null)
  }))
  default     = []
  description = "List of metric category settings."
}
