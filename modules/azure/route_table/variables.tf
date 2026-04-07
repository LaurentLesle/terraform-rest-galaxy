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

variable "route_table_name" {
  type        = string
  default     = null
  description = "The name of the route table."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "disable_bgp_route_propagation" {
  type        = bool
  default     = null
  description = "Whether to disable BGP route propagation."
}

variable "routes" {
  type = list(object({
    name                = string
    address_prefix      = string
    next_hop_type       = string
    next_hop_ip_address = optional(string)
  }))
  default     = null
  description = "List of routes."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
