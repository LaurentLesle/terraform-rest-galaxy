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

variable "virtual_hub_name" {
  type        = string
  default     = null
  description = "The name of the Virtual Hub."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region for the Virtual Hub."
}

variable "virtual_wan_id" {
  type        = string
  description = "The ARM resource ID of the Virtual WAN this hub belongs to."
}

variable "address_prefix" {
  type        = string
  description = "The address prefix (CIDR) for this Virtual Hub."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "sku" {
  type        = string
  default     = "Standard"
  description = "The SKU of this Virtual Hub (Basic or Standard)."
}

variable "allow_branch_to_branch_traffic" {
  type        = bool
  default     = null
  description = "Flag to control transit for VirtualRouter hub."
}

variable "hub_routing_preference" {
  type        = string
  default     = null
  description = "The hubRoutingPreference (ExpressRoute, VpnGateway, ASPath)."
}

variable "virtual_router_auto_scale_min_capacity" {
  type        = number
  default     = null
  description = "The minimum number of scale units for VirtualHub Router."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
