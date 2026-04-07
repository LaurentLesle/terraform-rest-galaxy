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

variable "connection_name" {
  type        = string
  description = "The name of the connection."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "connection_type" {
  type        = string
  description = "The connection type (IPsec, Vnet2Vnet, ExpressRoute)."
}

variable "virtual_network_gateway1_id" {
  type        = string
  description = "The resource ID of the first virtual network gateway."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "virtual_network_gateway2_id" {
  type        = string
  default     = null
  description = "The resource ID of the second virtual network gateway (Vnet2Vnet)."
}

variable "peer_id" {
  type        = string
  default     = null
  description = "The resource ID of the peer (ExpressRoute circuit or local network gateway)."
}

variable "routing_weight" {
  type        = number
  default     = null
  description = "The routing weight."
}

variable "enable_bgp" {
  type        = bool
  default     = null
  description = "Whether BGP is enabled."
}

variable "express_route_gateway_bypass" {
  type        = bool
  default     = null
  description = "Whether ExpressRoute gateway bypass (FastPath) is enabled."
}

variable "enable_private_link_fast_path" {
  type        = bool
  default     = null
  description = "Whether private link fast path is enabled."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
