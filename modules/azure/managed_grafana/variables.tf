# ── Provider behaviour ──────────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists."
}

# ── Scope ───────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID in which the Managed Grafana instance is created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the Managed Grafana instance."
}

# ── Identity ────────────────────────────────────────────────────────────────────

variable "grafana_name" {
  type        = string
  description = "The name of the Managed Grafana instance."
}

# ── Required body properties ────────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The geo-location where the Managed Grafana instance lives."
}

variable "sku_name" {
  type        = string
  default     = "Standard"
  description = "The SKU of the Managed Grafana instance. Typically 'Standard' or 'Essential'."
}

# ── Identity ────────────────────────────────────────────────────────────────────

variable "identity_type" {
  type        = string
  default     = null
  description = "The type of managed identity. Allowed values: SystemAssigned, UserAssigned, SystemAssigned,UserAssigned, None."

  validation {
    condition     = var.identity_type == null || contains(["SystemAssigned", "UserAssigned", "SystemAssigned,UserAssigned", "None"], var.identity_type)
    error_message = "identity_type must be one of: SystemAssigned, UserAssigned, SystemAssigned,UserAssigned, None."
  }
}

variable "identity_user_assigned_identity_ids" {
  type        = list(string)
  default     = null
  description = "List of user-assigned identity resource IDs to associate with the Managed Grafana instance."
}

# ── Optional body properties ────────────────────────────────────────────────────

variable "public_network_access" {
  type        = string
  default     = "Enabled"
  description = "Indicate the state for enable or disable traffic over the public interface. Allowed values: Enabled, Disabled."

  validation {
    condition     = contains(["Enabled", "Disabled"], var.public_network_access)
    error_message = "public_network_access must be 'Enabled' or 'Disabled'."
  }
}

variable "zone_redundancy" {
  type        = string
  default     = "Disabled"
  description = "The zone redundancy setting of the Grafana instance. Allowed values: Disabled, Enabled."

  validation {
    condition     = contains(["Disabled", "Enabled"], var.zone_redundancy)
    error_message = "zone_redundancy must be 'Disabled' or 'Enabled'."
  }
}

variable "api_key" {
  type        = string
  default     = "Disabled"
  description = "The API key setting of the Grafana instance. Allowed values: Disabled, Enabled."

  validation {
    condition     = contains(["Disabled", "Enabled"], var.api_key)
    error_message = "api_key must be 'Disabled' or 'Enabled'."
  }
}

variable "deterministic_outbound_ip" {
  type        = string
  default     = "Disabled"
  description = "Whether a Grafana instance uses deterministic outbound IPs. Allowed values: Disabled, Enabled."

  validation {
    condition     = contains(["Disabled", "Enabled"], var.deterministic_outbound_ip)
    error_message = "deterministic_outbound_ip must be 'Disabled' or 'Enabled'."
  }
}

variable "creator_can_admin" {
  type        = string
  default     = null
  description = "Whether the creator will have admin access for the Grafana instance. Allowed values: Disabled, Enabled."

  validation {
    condition     = var.creator_can_admin == null || contains(["Disabled", "Enabled"], var.creator_can_admin)
    error_message = "creator_can_admin must be 'Disabled' or 'Enabled'."
  }
}

variable "grafana_major_version" {
  type        = string
  default     = null
  description = "The major Grafana software version to target (e.g. '10')."
}

variable "azure_monitor_workspace_integrations" {
  type = list(object({
    azure_monitor_workspace_resource_id = string
  }))
  default     = null
  description = "List of Azure Monitor Workspace integrations to configure with this Grafana instance."
}

variable "grafana_configurations_smtp" {
  type = object({
    enabled          = optional(bool, false)
    host             = optional(string, null)
    user             = optional(string, null)
    password         = optional(string, null)
    from_address     = optional(string, null)
    from_name        = optional(string, null)
    start_tls_policy = optional(string, null)
    skip_verify      = optional(bool, null)
  })
  default     = null
  description = "SMTP email server configuration for the Grafana instance."
}

variable "grafana_configurations_snapshots_external_enabled" {
  type        = bool
  default     = null
  description = "When true, external snapshot sharing is enabled in Grafana."
}

variable "grafana_configurations_users_viewers_can_edit" {
  type        = bool
  default     = null
  description = "When true, viewers can edit dashboards without saving them."
}

variable "grafana_configurations_users_editors_can_admin" {
  type        = bool
  default     = null
  description = "When true, editors can administrate dashboards, folders and teams."
}

variable "enterprise_marketplace_plan_id" {
  type        = string
  default     = null
  description = "The Plan Id of the Azure Marketplace subscription for the Grafana Enterprise plugins."
}

variable "enterprise_marketplace_auto_renew" {
  type        = string
  default     = null
  description = "The AutoRenew setting of the Grafana Enterprise subscription. Allowed values: Enabled, Disabled."

  validation {
    condition     = var.enterprise_marketplace_auto_renew == null || contains(["Enabled", "Disabled"], var.enterprise_marketplace_auto_renew)
    error_message = "enterprise_marketplace_auto_renew must be 'Enabled' or 'Disabled'."
  }
}

variable "grafana_plugins" {
  type        = map(any)
  default     = null
  description = "Map of Grafana plugins to install. Key is plugin id, value is plugin definition object (or null to remove a plugin)."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
