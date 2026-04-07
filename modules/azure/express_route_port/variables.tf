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

variable "port_name" {
  type        = string
  description = "The name of the ExpressRoute port."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "peering_location" {
  type        = string
  description = "The name of the peering location that the ExpressRoute port is mapped to physically."
}

variable "bandwidth_in_gbps" {
  type        = number
  description = "Bandwidth of procured ports in Gbps."
}

variable "encapsulation" {
  type        = string
  description = "Encapsulation method on physical ports (Dot1Q or QinQ)."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "billing_type" {
  type        = string
  default     = null
  description = "The billing type of the ExpressRoute port resource (MeteredData or UnlimitedData)."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
