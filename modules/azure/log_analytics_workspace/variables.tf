# ── Provider behaviour ──────────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists."
}

# ── Scope ───────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID in which the Log Analytics Workspace is created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the Log Analytics Workspace."
}

# ── Identity ────────────────────────────────────────────────────────────────────

variable "workspace_name" {
  type        = string
  default     = null
  description = "The name of the Log Analytics Workspace. Must be 4–63 characters, alphanumeric and hyphens only, globally unique. When null, the for_each key is used."

  validation {
    condition     = var.workspace_name == null || can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]{2,61}[a-zA-Z0-9]$", var.workspace_name))
    error_message = "workspace_name must be 4–63 characters, start and end with alphanumeric, and contain only letters, digits, and hyphens."
  }
}

# ── Required body properties ────────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The geo-location where the Log Analytics Workspace lives."
}

# ── Optional body properties ────────────────────────────────────────────────────

variable "sku_name" {
  type        = string
  default     = "PerGB2018"
  description = "The SKU of the workspace. Allowed values: Free, Standard, Premium, PerNode, PerGB2018, Standalone, CapacityReservation, LACluster."

  validation {
    condition     = contains(["Free", "Standard", "Premium", "PerNode", "PerGB2018", "Standalone", "CapacityReservation", "LACluster"], var.sku_name)
    error_message = "sku_name must be one of: Free, Standard, Premium, PerNode, PerGB2018, Standalone, CapacityReservation, LACluster."
  }
}

variable "sku_capacity_reservation_level" {
  type        = number
  default     = null
  description = "The capacity reservation level in GB. Required when sku_name is CapacityReservation. Allowed values: 100, 200, 300, 400, 500, 1000, 2000, 5000, 10000, 25000, 50000."
}

variable "retention_in_days" {
  type        = number
  default     = null
  description = "The workspace data retention in days. Allowed values are per pricing plan."
}

variable "daily_quota_gb" {
  type        = number
  default     = null
  description = "The workspace daily quota for ingestion in GB (-1 = unlimited)."
}

variable "public_network_access_for_ingestion" {
  type        = string
  default     = "Enabled"
  description = "The network access type for accessing Log Analytics ingestion. Allowed values: Enabled, Disabled, SecuredByPerimeter."

  validation {
    condition     = contains(["Enabled", "Disabled", "SecuredByPerimeter"], var.public_network_access_for_ingestion)
    error_message = "public_network_access_for_ingestion must be one of: Enabled, Disabled, SecuredByPerimeter."
  }
}

variable "public_network_access_for_query" {
  type        = string
  default     = "Enabled"
  description = "The network access type for accessing Log Analytics query. Allowed values: Enabled, Disabled, SecuredByPerimeter."

  validation {
    condition     = contains(["Enabled", "Disabled", "SecuredByPerimeter"], var.public_network_access_for_query)
    error_message = "public_network_access_for_query must be one of: Enabled, Disabled, SecuredByPerimeter."
  }
}

variable "force_cmk_for_query" {
  type        = bool
  default     = null
  description = "Indicates whether customer managed storage is mandatory for query management."
}

variable "features_enable_data_export" {
  type        = bool
  default     = null
  description = "Flag that indicates if data should be exported."
}

variable "features_immediate_purge_data_on_30_days" {
  type        = bool
  default     = null
  description = "Flag that describes if data should be removed after 30 days."
}

variable "features_enable_log_access_using_only_resource_permissions" {
  type        = bool
  default     = null
  description = "Flag that indicates which permission to use — resource or workspace or both."
}

variable "features_cluster_resource_id" {
  type        = string
  default     = null
  description = "Dedicated LA cluster resourceId that is linked to the workspace."
}

variable "features_disable_local_auth" {
  type        = bool
  default     = true
  description = "Disable Non-AAD based Auth. Defaults to true for SOC2 compliance."
}

variable "default_data_collection_rule_resource_id" {
  type        = string
  default     = null
  description = "The resource ID of the default Data Collection Rule to use for this workspace."
}

# ── Managed Identity ────────────────────────────────────────────────────────────

variable "identity_type" {
  type        = string
  default     = null
  description = "The type of managed identity to assign to the workspace. Allowed values: SystemAssigned, UserAssigned, None."

  validation {
    condition     = var.identity_type == null || contains(["SystemAssigned", "UserAssigned", "None"], var.identity_type)
    error_message = "identity_type must be one of: SystemAssigned, UserAssigned, None."
  }
}

variable "identity_user_assigned_identity_ids" {
  type        = list(string)
  default     = null
  description = "List of user-assigned identity resource IDs. Required when identity_type is UserAssigned."
}

# ── Replication ─────────────────────────────────────────────────────────────────

variable "replication_enabled" {
  type        = bool
  default     = null
  description = "When true, workspace configuration and data is replicated to the replication_location. Requires replication_location to be set."
}

variable "replication_location" {
  type        = string
  default     = null
  description = "The Azure region for workspace replication. Immutable once set (x-ms-mutability: read, create). Required when replication_enabled is true."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
