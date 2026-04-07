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

variable "pool_name" {
  type        = string
  description = "The name of the parent IPAM pool."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "static_cidr_name" {
  type        = string
  description = "The name of the static CIDR allocation."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "address_prefixes" {
  type        = list(string)
  default     = null
  description = "List of IP address prefixes to reserve. Either this or number_of_ip_addresses_to_allocate must be set."
}

variable "number_of_ip_addresses_to_allocate" {
  type        = string
  default     = null
  description = "Number of IP addresses to allocate from the pool. The addresses are auto-assigned."
}

variable "description" {
  type        = string
  default     = null
  description = "A description of the static CIDR allocation."
}
