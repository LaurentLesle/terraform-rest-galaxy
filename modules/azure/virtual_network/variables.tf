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

variable "virtual_network_name" {
  type        = string
  default     = null
  description = "The name of the virtual network."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "address_space" {
  type        = list(string)
  description = "List of address prefixes for the virtual network."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "dns_servers" {
  type        = list(string)
  default     = null
  description = "List of DNS server IP addresses."
}

variable "enable_ddos_protection" {
  type        = bool
  default     = null
  description = "Whether DDoS protection is enabled."
}

variable "ddos_protection_plan_id" {
  type        = string
  default     = null
  description = "ARM resource ID of the DDoS protection plan."
}

variable "subnets" {
  type = list(object({
    name                              = string
    address_prefix                    = string
    route_table_id                    = optional(string)
    network_security_group_id         = optional(string)
    delegations                       = optional(list(string))
    private_endpoint_network_policies = optional(string)
  }))
  default     = null
  description = "List of subnets to create within the virtual network."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
