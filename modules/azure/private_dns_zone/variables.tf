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

variable "zone_name" {
  type        = string
  description = "The name of the Private DNS zone (e.g. privatelink.blob.core.windows.net)."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}

variable "virtual_network_links" {
  type = list(object({
    name                 = string
    virtual_network_id   = string
    registration_enabled = optional(bool, false)
    resolution_policy    = optional(string)
    tags                 = optional(map(string))
  }))
  default     = []
  description = "List of virtual network links to create for this Private DNS zone."
}
