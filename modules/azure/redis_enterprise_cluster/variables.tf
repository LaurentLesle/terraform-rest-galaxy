# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it."
}

# ── Scope ────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "cluster_name" {
  type        = string
  description = "The name of the Redis Enterprise cluster."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region for the Redis Enterprise cluster."
}

variable "sku_name" {
  type        = string
  description = "The SKU name (e.g. Enterprise_E10, Enterprise_E5, Balanced_B5, etc.)."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "sku_capacity" {
  type        = number
  default     = null
  description = "The capacity of the SKU. Valid values are (2, 4, 6, ...) for Enterprise and (3, 9, 15, ...) for EnterpriseFlash."
}

variable "zones" {
  type        = list(string)
  default     = null
  description = "The Availability Zones where this cluster will be deployed."
}

variable "minimum_tls_version" {
  type        = string
  default     = "1.2"
  description = "The minimum TLS version for the cluster to support. One of: '1.0', '1.1', '1.2'."
}

variable "high_availability" {
  type        = string
  default     = null
  description = "High availability setting. One of: 'Enabled', 'Disabled'. Enabled by default."
}

variable "public_network_access" {
  type        = string
  default     = "Disabled"
  description = "Whether public network access is allowed. One of: 'Enabled', 'Disabled'."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
