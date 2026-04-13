# ── Provider behaviour ──────────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists."
}

# ── Scope ───────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID in which the virtual network link is created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the Private DNS Zone."
}

variable "private_dns_zone_name" {
  type        = string
  description = "The name of the Private DNS Zone to link to the virtual network (e.g. 'privatelink.monitor.azure.com')."
}

# ── Identity ────────────────────────────────────────────────────────────────────

variable "virtual_network_link_name" {
  type        = string
  description = "The name of the virtual network link resource."

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9._-]{0,78}[a-zA-Z0-9]$|^[a-zA-Z0-9]$", var.virtual_network_link_name))
    error_message = "virtual_network_link_name must be 1-80 characters, start and end with an alphanumeric character, and contain only letters, digits, hyphens, underscores, and periods."
  }
}

# ── Required body properties ────────────────────────────────────────────────────

variable "virtual_network_id" {
  type        = string
  description = "The ARM resource ID of the virtual network to link to the Private DNS Zone."
}

variable "registration_enabled" {
  type        = bool
  default     = false
  description = "Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled? Defaults to false."
}

# ── Optional body properties ────────────────────────────────────────────────────

variable "resolution_policy" {
  type        = string
  default     = null
  description = "The resolution policy on the virtual network link. Only applicable for virtualnetwork links to privatelink zones, and for A,AAAA,CNAME queries. Allowed values: 'Default', 'NxDomainRedirect'."

  validation {
    condition     = var.resolution_policy == null || contains(["Default", "NxDomainRedirect"], var.resolution_policy)
    error_message = "resolution_policy must be 'Default' or 'NxDomainRedirect'."
  }
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
