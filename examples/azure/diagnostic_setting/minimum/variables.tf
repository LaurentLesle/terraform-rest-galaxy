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
  description = "The full ARM resource ID of the Log Analytics workspace to send logs to."
}
