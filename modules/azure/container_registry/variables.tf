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

variable "registry_name" {
  type        = string
  description = "The name of the container registry. Globally unique, 5–50 alphanumeric characters."

  validation {
    condition     = can(regex("^[a-zA-Z0-9]{5,50}$", var.registry_name))
    error_message = "registry_name must be 5–50 alphanumeric characters."
  }
}

# ── Required body properties ──────────────────────────────────────────────────

variable "sku_name" {
  type        = string
  description = "The SKU name. Options: Basic, Standard, Premium."
  default     = "Basic"

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku_name)
    error_message = "sku_name must be one of: Basic, Standard, Premium."
  }
}

variable "location" {
  type        = string
  description = "The Azure region."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags to assign to the container registry."
}

variable "admin_user_enabled" {
  type        = bool
  default     = false
  description = "Whether the admin user is enabled."
}

variable "public_network_access" {
  type        = string
  default     = null
  description = "Whether public network access is allowed. Options: Enabled, Disabled."
}

variable "anonymous_pull_enabled" {
  type        = bool
  default     = null
  description = "Whether anonymous pull is enabled (registry-wide)."
}

variable "check_existance" {
  type        = bool
  default     = false
  description = "When true, import existing resource instead of creating."
}
