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
  description = "The name of the VPN gateway."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "virtual_hub_id" {
  type        = string
  description = "The ARM resource ID of the Virtual Hub this VPN gateway belongs to."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "vpn_gateway_scale_unit" {
  type        = number
  default     = null
  description = "The scale unit for this VPN gateway."
}

variable "enable_bgp_route_translation_for_nat" {
  type        = bool
  default     = null
  description = "Enable BGP routes translation for NAT on this VPN gateway."
}

variable "is_routing_preference_internet" {
  type        = bool
  default     = null
  description = "Enable Routing Preference property for the Public IP Interface of the VPN gateway."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
