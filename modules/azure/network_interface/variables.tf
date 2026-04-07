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

variable "network_interface_name" {
  type        = string
  description = "The name of the network interface."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "ip_configurations" {
  type = list(object({
    name                         = string
    subnet_id                    = optional(string)
    private_ip_address           = optional(string)
    private_ip_allocation_method = optional(string)
    private_ip_address_version   = optional(string)
    primary                      = optional(bool)
  }))
  description = "IP configurations for the NIC."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "enable_accelerated_networking" {
  type        = bool
  default     = null
  description = "Whether accelerated networking is enabled."
}

variable "enable_ip_forwarding" {
  type        = bool
  default     = null
  description = "Whether IP forwarding is enabled."
}

variable "dns_servers" {
  type        = list(string)
  default     = null
  description = "DNS servers for the NIC."
}

variable "network_security_group_id" {
  type        = string
  default     = null
  description = "The resource ID of the NSG to associate."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
