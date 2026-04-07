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

variable "virtual_hub_name" {
  type        = string
  description = "The name of the Virtual Hub."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "connection_name" {
  type        = string
  description = "The name of the hub virtual network connection."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "remote_virtual_network_id" {
  type        = string
  description = "The ARM resource ID of the remote virtual network."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "enable_internet_security" {
  type        = bool
  default     = null
  description = "Enable internet security (default route through the hub)."
}

variable "allow_hub_to_remote_vnet_transit" {
  type        = bool
  default     = null
  description = "Allow hub to remote VNet transit."
}

variable "allow_remote_vnet_to_use_hub_vnet_gateways" {
  type        = bool
  default     = null
  description = "Allow remote VNet to use hub VNet gateways."
}
