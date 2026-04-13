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

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "application_insights_name" {
  type        = string
  description = "The name of the Application Insights component."
}

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "kind" {
  type        = string
  default     = "web"
  description = "The kind of application."
}

variable "application_type" {
  type        = string
  default     = "web"
  description = "Type of application being monitored (web or other)."
}

variable "workspace_resource_id" {
  type        = string
  default     = null
  description = "Resource ID of the Log Analytics Workspace."
}

variable "retention_in_days" {
  type        = number
  default     = 90
  description = "Retention period in days."
}

variable "sampling_percentage" {
  type        = number
  default     = null
  description = "Percentage of data sampled for telemetry (0-100)."
}

variable "disable_ip_masking" {
  type        = bool
  default     = false
  description = "Disable IP masking."
}

variable "public_network_access_for_ingestion" {
  type        = string
  default     = "Enabled"
  description = "Network access type for ingestion (Enabled or Disabled)."
}

variable "public_network_access_for_query" {
  type        = string
  default     = "Enabled"
  description = "Network access type for query (Enabled or Disabled)."
}

variable "ingestion_mode" {
  type        = string
  default     = "LogAnalytics"
  description = "Ingestion mode (ApplicationInsights, ApplicationInsightsWithDiagnosticSettings, LogAnalytics)."
}

variable "disable_local_auth" {
  type        = bool
  default     = true
  description = "Disable Non-AAD based Auth."
}

variable "force_customer_storage_for_profiler" {
  type        = bool
  default     = false
  description = "Force users to create their own storage for profiler."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
