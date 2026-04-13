# ── Provider behaviour ──────────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists."
}

# ── Scope ───────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID in which the Data Collection Rule is created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the Data Collection Rule."
}

# ── Identity ────────────────────────────────────────────────────────────────────

variable "data_collection_rule_name" {
  type        = string
  description = "The name of the Data Collection Rule."
}

# ── Required body properties ────────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The geo-location where the Data Collection Rule lives."
}

# ── Optional body properties ────────────────────────────────────────────────────

variable "description" {
  type        = string
  default     = null
  description = "Description of the data collection rule."
}

variable "kind" {
  type        = string
  default     = null
  description = "The kind of the resource. Allowed values: Linux, Windows, AgentDirectToStore, WorkspaceTransforms."

  validation {
    condition     = var.kind == null || contains(["Linux", "Windows", "AgentDirectToStore", "WorkspaceTransforms"], var.kind)
    error_message = "kind must be one of: Linux, Windows, AgentDirectToStore, WorkspaceTransforms."
  }
}

variable "data_collection_endpoint_id" {
  type        = string
  default     = null
  description = "The resource ID of the data collection endpoint that this rule is associated with."
}

variable "stream_declarations" {
  type        = map(any)
  default     = null
  description = "Map of custom stream declarations. Key is stream name, value is object with 'columns' list."
}

variable "data_sources" {
  type        = any
  default     = null
  description = "The specification of data sources. Supports performanceCounters, windowsEventLogs, syslog, extensions, logFiles, iisLogs, logAnalytics, prometheusForwarder."
}

variable "direct_data_sources" {
  type        = any
  default     = null
  description = "The specification of direct data sources (API 2024-03-11+)."
}

variable "destinations" {
  type        = any
  default     = null
  description = "The specification of destinations. Supports logAnalytics, azureMonitorMetrics, eventHub, storageAccounts, storageBlobsDirect, storageTablesDirect."
}

variable "references" {
  type        = any
  default     = null
  description = "Defines all the references that may be used in other sections of the DCR (API 2024-03-11+)."
}

variable "agent_settings" {
  type        = any
  default     = null
  description = "Agent settings used to modify agent behavior on a given host (API 2024-03-11+)."
}

variable "data_flows" {
  type = list(object({
    streams            = list(string)
    destinations       = list(string)
    transform_kql      = optional(string, null)
    output_stream      = optional(string, null)
    built_in_transform = optional(string, null)
  }))
  default     = null
  description = "The specification of data flows mapping streams to destinations."
}

variable "identity_type" {
  type        = string
  default     = null
  description = "The type of managed identity. Allowed values: SystemAssigned, UserAssigned, None."

  validation {
    condition     = var.identity_type == null || contains(["SystemAssigned", "UserAssigned", "None"], var.identity_type)
    error_message = "identity_type must be one of: SystemAssigned, UserAssigned, None."
  }
}

variable "identity_user_assigned_identity_ids" {
  type        = list(string)
  default     = null
  description = "List of user-assigned identity resource IDs."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
