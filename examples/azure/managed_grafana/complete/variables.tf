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

variable "grafana_name" {
  type        = string
  description = "The name of the Managed Grafana instance."
}

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "sku_name" {
  type        = string
  default     = "Standard"
  description = "The SKU name for the Managed Grafana instance."
}

variable "public_network_access" {
  type        = string
  default     = "Enabled"
  description = "Whether public network access is enabled (Enabled or Disabled)."
}

variable "zone_redundancy" {
  type        = string
  default     = "Disabled"
  description = "Whether zone redundancy is enabled (Enabled or Disabled)."
}

variable "api_key" {
  type        = string
  default     = "Disabled"
  description = "Whether API key authentication is enabled (Enabled or Disabled)."
}

variable "deterministic_outbound_ip" {
  type        = string
  default     = "Disabled"
  description = "Whether deterministic outbound IP is enabled (Enabled or Disabled)."
}

variable "azure_monitor_workspace_integrations" {
  type = list(object({
    azure_monitor_workspace_resource_id = string
  }))
  default     = null
  description = "List of Azure Monitor workspace integrations."
}

variable "grafana_configurations_snapshots_external_enabled" {
  type        = bool
  default     = null
  description = "Whether external snapshots are enabled."
}

variable "grafana_configurations_users_viewers_can_edit" {
  type        = bool
  default     = null
  description = "Whether viewers can edit dashboards."
}

variable "grafana_configurations_users_editors_can_admin" {
  type        = bool
  default     = null
  description = "Whether editors have admin privileges."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the Managed Grafana instance."
}
