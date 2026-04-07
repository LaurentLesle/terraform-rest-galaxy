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

# ── Parent scope ──────────────────────────────────────────────────────────────

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "server_name" {
  type        = string
  default     = null
  description = "The name of the PostgreSQL Flexible Server."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region."
}

# ── SKU ───────────────────────────────────────────────────────────────────────

variable "sku_name" {
  type        = string
  default     = "Standard_D2ds_v5"
  description = "Compute SKU name (e.g. Standard_B1ms, Standard_D2ds_v5)."
}

variable "sku_tier" {
  type        = string
  default     = "GeneralPurpose"
  description = "SKU tier. Options: Burstable, GeneralPurpose, MemoryOptimized."
}

# ── Version ───────────────────────────────────────────────────────────────────

variable "server_version" {
  type        = string
  default     = "16"
  description = "PostgreSQL major version. Options: 12, 13, 14, 15, 16, 17, 18."
}

# ── Authentication ────────────────────────────────────────────────────────────

variable "administrator_login" {
  type        = string
  default     = null
  description = "The administrator login name. Required when password auth is enabled."
}

variable "administrator_login_password" {
  type        = string
  default     = null
  sensitive   = true
  description = "The administrator login password. Required when password auth is enabled."
}

variable "active_directory_auth" {
  type        = string
  default     = null
  description = "Enable Microsoft Entra authentication. Options: Enabled, Disabled."
}

variable "password_auth" {
  type        = string
  default     = null
  description = "Enable password authentication. Options: Enabled, Disabled."
}

variable "auth_tenant_id" {
  type        = string
  default     = null
  description = "Tenant ID for Entra authentication."
}

# ── Storage ───────────────────────────────────────────────────────────────────

variable "storage_size_gb" {
  type        = number
  default     = 32
  description = "Storage size in GB."
}

variable "storage_auto_grow" {
  type        = string
  default     = null
  description = "Enable auto-grow for storage. Options: Enabled, Disabled."
}

variable "storage_tier" {
  type        = string
  default     = null
  description = "Storage performance tier (e.g. P10, P20, P30)."
}

# ── Backup ────────────────────────────────────────────────────────────────────

variable "backup_retention_days" {
  type        = number
  default     = null
  description = "Backup retention days (7-35)."
}

variable "geo_redundant_backup" {
  type        = string
  default     = null
  description = "Enable geo-redundant backup. Options: Enabled, Disabled."
}

# ── High availability ────────────────────────────────────────────────────────

variable "ha_mode" {
  type        = string
  default     = null
  description = "High availability mode. Options: Disabled, SameZone, ZoneRedundant."
}

variable "ha_standby_availability_zone" {
  type        = string
  default     = null
  description = "Availability zone for the standby server."
}

# ── Network ───────────────────────────────────────────────────────────────────

variable "delegated_subnet_id" {
  type        = string
  default     = null
  description = "Resource ID of the delegated subnet for VNet integration."
}

variable "private_dns_zone_id" {
  type        = string
  default     = null
  description = "Resource ID of the private DNS zone for VNet-integrated servers."
}

variable "public_network_access" {
  type        = string
  default     = null
  description = "Public network access. Options: Enabled, Disabled."
}

# ── Availability zone ────────────────────────────────────────────────────────

variable "availability_zone" {
  type        = string
  default     = null
  description = "Availability zone."
}

# ── Maintenance window ───────────────────────────────────────────────────────

variable "maintenance_window" {
  type = object({
    custom_window = optional(string, "Disabled")
    start_hour    = optional(number, 0)
    start_minute  = optional(number, 0)
    day_of_week   = optional(number, 0)
  })
  default     = null
  description = "Maintenance window configuration."
}

# ── Tags ──────────────────────────────────────────────────────────────────────

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags."
}
