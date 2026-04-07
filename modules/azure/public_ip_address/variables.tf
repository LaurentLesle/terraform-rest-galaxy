# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows."
}

# ── Scope ────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group name."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "public_ip_address_name" {
  type        = string
  default     = null
  description = "The name of the public IP address."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "sku_name" {
  type        = string
  description = "The SKU name (Basic or Standard)."
}

variable "sku_tier" {
  type        = string
  default     = "Regional"
  nullable    = false
  description = "The SKU tier (Regional or Global)."
}

variable "allocation_method" {
  type        = string
  description = "The allocation method (Static or Dynamic)."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "ip_version" {
  type        = string
  default     = null
  description = "The IP address version (IPv4 or IPv6)."
}

variable "idle_timeout_in_minutes" {
  type        = number
  default     = null
  description = "Idle timeout in minutes."
}

variable "zones" {
  type        = list(string)
  default     = null
  description = "A list of availability zones."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
