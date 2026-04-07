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

# ── Identity ──────────────────────────────────────────────────────────────────

variable "zone_name" {
  type        = string
  description = "The name of the DNS zone (e.g. contoso.com)."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  default     = "global"
  description = "The location of the DNS zone. Must be 'global' for public zones."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "zone_type" {
  type        = string
  default     = "Public"
  description = "The type of DNS zone. Options: Public, Private."

  validation {
    condition     = contains(["Public", "Private"], var.zone_type)
    error_message = "zone_type must be one of: Public, Private."
  }
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags to assign to the DNS zone."
}
