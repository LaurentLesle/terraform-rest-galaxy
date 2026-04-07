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

variable "circuit_name" {
  type        = string
  default     = null
  description = "The name of the ExpressRoute circuit."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "sku_tier" {
  type        = string
  description = "The SKU tier (Standard, Premium, Local)."
}

variable "sku_family" {
  type        = string
  description = "The SKU family (MeteredData, UnlimitedData)."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "bandwidth_in_gbps" {
  type        = number
  default     = null
  description = "Bandwidth in Gbps (for ExpressRoute Direct)."
}

variable "bandwidth_in_mbps" {
  type        = number
  default     = null
  description = "Bandwidth in Mbps (for provider-based circuits)."
}

variable "express_route_port_id" {
  type        = string
  default     = null
  description = "ARM resource ID of the ExpressRoute port (for Direct circuits)."
}

variable "service_provider_name" {
  type        = string
  default     = null
  description = "The service provider name (for provider-based circuits)."
}

variable "peering_location" {
  type        = string
  default     = null
  description = "The peering location (for provider-based circuits)."
}

variable "allow_classic_operations" {
  type        = bool
  default     = null
  description = "Allow classic operations."
}

variable "global_reach_enabled" {
  type        = bool
  default     = null
  description = "Enable Global Reach."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
