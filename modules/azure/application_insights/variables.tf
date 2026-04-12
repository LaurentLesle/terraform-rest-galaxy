# Source: azure-rest-api-specs
#   spec_path  : applicationinsights/resource-manager/Microsoft.Insights/ApplicationInsights
#   api_version: 2020-02-02
#   swagger    : components_API.json

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

variable "application_insights_name" {
  type        = string
  description = "The name of the Application Insights component."
}

variable "location" {
  type        = string
  description = "Resource location."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}

variable "kind" {
  type        = string
  default     = "web"
  description = "The kind of application that this component refers to (web, ios, other, store, java, phone)."
}

variable "etag" {
  type        = string
  default     = null
  description = "Resource etag."
}

# ── Required properties ────────────────────────────────────────────────────

variable "application_type" {
  type        = string
  default     = "web"
  description = "Type of application being monitored (web or other)."

  validation {
    condition     = var.application_type == null || contains(["web", "other"], var.application_type)
    error_message = "application_type must be 'web' or 'other'."
  }
}

# ── Optional properties ────────────────────────────────────────────────────

variable "workspace_resource_id" {
  type        = string
  default     = null
  description = "Resource ID of the log analytics workspace which data will be ingested to. Required for workspace-based Application Insights."
}

variable "flow_type" {
  type        = string
  default     = "Bluefield"
  description = "Used by Application Insights system to determine the kind of flow. Set to 'Bluefield' when creating/updating via REST API."

  validation {
    condition     = var.flow_type == null || var.flow_type == "Bluefield"
    error_message = "flow_type must be 'Bluefield'."
  }
}

variable "request_source" {
  type        = string
  default     = "rest"
  description = "Describes what tool created this Application Insights component. Set to 'rest' when using this API."

  validation {
    condition     = var.request_source == null || var.request_source == "rest"
    error_message = "request_source must be 'rest'."
  }
}

variable "retention_in_days" {
  type        = number
  default     = 90
  description = "Retention period in days. Defaults to 90 for compliance."

  validation {
    condition     = var.retention_in_days == null || contains([30, 60, 90, 120, 180, 270, 365, 550, 730], var.retention_in_days)
    error_message = "retention_in_days must be one of: 30, 60, 90, 120, 180, 270, 365, 550, 730."
  }
}

variable "sampling_percentage" {
  type        = number
  default     = null
  description = "Percentage of the data produced by the application being monitored that is sampled for telemetry."

  validation {
    condition     = var.sampling_percentage == null || (var.sampling_percentage >= 0 && var.sampling_percentage <= 100)
    error_message = "sampling_percentage must be between 0 and 100."
  }
}

variable "disable_ip_masking" {
  type        = bool
  default     = false
  description = "Disable IP masking. Default is false (IP masking enabled) for compliance."
}

variable "immediate_purge_data_on30_days" {
  type        = bool
  default     = null
  description = "Purge data immediately after 30 days."
}

variable "hockey_app_id" {
  type        = string
  default     = null
  description = "The unique application ID created when a new application is added to HockeyApp."
}

variable "public_network_access_for_ingestion" {
  type        = string
  default     = "Enabled"
  description = "The network access type for accessing Application Insights ingestion (Enabled or Disabled)."

  validation {
    condition     = var.public_network_access_for_ingestion == null || contains(["Enabled", "Disabled"], var.public_network_access_for_ingestion)
    error_message = "public_network_access_for_ingestion must be 'Enabled' or 'Disabled'."
  }
}

variable "public_network_access_for_query" {
  type        = string
  default     = "Enabled"
  description = "The network access type for accessing Application Insights query (Enabled or Disabled)."

  validation {
    condition     = var.public_network_access_for_query == null || contains(["Enabled", "Disabled"], var.public_network_access_for_query)
    error_message = "public_network_access_for_query must be 'Enabled' or 'Disabled'."
  }
}

variable "ingestion_mode" {
  type        = string
  default     = "LogAnalytics"
  description = "Indicates the flow of the ingestion (ApplicationInsights, ApplicationInsightsWithDiagnosticSettings, or LogAnalytics)."

  validation {
    condition     = var.ingestion_mode == null || contains(["ApplicationInsights", "ApplicationInsightsWithDiagnosticSettings", "LogAnalytics"], var.ingestion_mode)
    error_message = "ingestion_mode must be one of: ApplicationInsights, ApplicationInsightsWithDiagnosticSettings, LogAnalytics."
  }
}

variable "disable_local_auth" {
  type        = bool
  default     = true
  description = "Disable Non-AAD based Auth. Default is true for SOC2 compliance."
}

variable "force_customer_storage_for_profiler" {
  type        = bool
  default     = false
  description = "Force users to create their own storage account for profiler and debugger."
}
