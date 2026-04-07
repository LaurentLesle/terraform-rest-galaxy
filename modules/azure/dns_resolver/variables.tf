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

variable "dns_resolver_name" {
  type        = string
  description = "The name of the DNS resolver."
}

# ── Required ──────────────────────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "virtual_network_id" {
  type        = string
  description = "The resource ID of the virtual network to attach the DNS resolver to."
}

# ── Inbound Endpoints ────────────────────────────────────────────────────────

variable "inbound_endpoints" {
  type = list(object({
    name                         = string
    subnet_id                    = string
    private_ip_address           = optional(string, null)
    private_ip_allocation_method = optional(string, "Dynamic")
  }))
  default     = []
  description = "List of inbound endpoints. Each requires a dedicated subnet (min /28)."
}

# ── Optional ─────────────────────────────────────────────────────────────────

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it."
}
