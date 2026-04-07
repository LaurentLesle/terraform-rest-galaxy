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

variable "network_manager_name" {
  type        = string
  description = "The name of the parent network manager."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "pool_name" {
  type        = string
  description = "The name of the IPAM pool."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "address_prefixes" {
  type        = list(string)
  description = "List of IP address prefixes for the pool."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "description" {
  type        = string
  default     = null
  description = "A description of the IPAM pool."
}

variable "display_name" {
  type        = string
  default     = null
  description = "A friendly display name for the pool."
}

variable "parent_pool_name" {
  type        = string
  default     = null
  description = "The name of the parent pool. Empty or null for root pools."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
