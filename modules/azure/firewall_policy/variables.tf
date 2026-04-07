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

variable "firewall_policy_name" {
  type        = string
  default     = null
  description = "The name of the Firewall Policy."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region for the Firewall Policy."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "sku_tier" {
  type        = string
  default     = "Standard"
  description = "Tier of the Firewall Policy (Basic, Standard, Premium)."
}

variable "base_policy_id" {
  type        = string
  default     = null
  description = "The ARM resource ID of the parent firewall policy from which rules are inherited."
}

variable "threat_intel_mode" {
  type        = string
  default     = null
  description = "The operation mode for Threat Intelligence (Alert, Deny, Off)."
}

variable "dns_servers" {
  type        = list(string)
  default     = null
  description = "List of custom DNS server IP addresses."
}

variable "dns_proxy_enabled" {
  type        = bool
  default     = null
  description = "Enable DNS Proxy on firewalls attached to this policy."
}

variable "explicit_proxy" {
  type = object({
    enable_explicit_proxy = bool
    http_port             = optional(number)
    https_port            = optional(number)
    enable_pac_file       = optional(bool)
    pac_file_port         = optional(number)
    pac_file_sas_url      = optional(string)
  })
  default     = null
  description = "Explicit proxy settings for the Firewall Policy."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
