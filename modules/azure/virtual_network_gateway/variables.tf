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

variable "gateway_name" {
  type        = string
  default     = null
  description = "The name of the virtual network gateway."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "gateway_type" {
  type        = string
  description = "The gateway type (Vpn or ExpressRoute)."
}

variable "sku_name" {
  type        = string
  description = "The SKU name (e.g. VpnGw1, ErGw1AZ, UltraPerformance)."
}

variable "sku_tier" {
  type        = string
  description = "The SKU tier."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "vpn_type" {
  type        = string
  default     = null
  description = "The VPN type (PolicyBased, RouteBased)."
}

variable "vpn_gateway_generation" {
  type        = string
  default     = null
  description = "The VPN gateway generation (None, Generation1, Generation2)."
}

variable "enable_bgp" {
  type        = bool
  default     = null
  description = "Whether BGP is enabled."
}

variable "active_active" {
  type        = bool
  default     = null
  description = "Whether active-active mode is enabled."
}

variable "enable_private_ip_address" {
  type        = bool
  default     = null
  description = "Whether private IP is enabled."
}

variable "admin_state" {
  type        = string
  default     = null
  description = "The admin state (Enabled, Disabled)."
}

variable "ip_configurations" {
  type = list(object({
    name                 = string
    subnet_id            = optional(string)
    public_ip_address_id = optional(string)
  }))
  default     = null
  description = "IP configurations for the gateway."
}

variable "vpn_client_configuration" {
  type = object({
    address_prefixes         = list(string)
    vpn_client_protocols     = optional(list(string))
    vpn_authentication_types = optional(list(string))
    aad_tenant               = optional(string)
    aad_audience             = optional(string)
    aad_issuer               = optional(string)
    radius_server_address    = optional(string)
    radius_server_secret     = optional(string)
  })
  default     = null
  description = "P2S VPN client configuration. Required for Point-to-Site VPN."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
