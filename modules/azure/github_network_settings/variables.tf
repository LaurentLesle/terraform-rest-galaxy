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
  description = "The resource group name."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "network_settings_name" {
  type        = string
  default     = null
  description = "The name of the GitHub.Network networkSettings resource."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "subnet_id" {
  type        = string
  description = "The full ARM resource ID of the subnet delegated to GitHub.Network/networkSettings."
}

variable "business_id" {
  type        = string
  description = "The GitHub database ID of the organization or enterprise."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
