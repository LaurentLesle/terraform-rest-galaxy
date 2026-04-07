# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it."
}

# ── Scope ────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID."
}

# ── Parent scope ──────────────────────────────────────────────────────────────

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group containing the local virtual network."
}

variable "virtual_network_name" {
  type        = string
  description = "The name of the local virtual network being peered."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "peering_name" {
  type        = string
  default     = null
  description = "The name of the VNet peering."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "remote_virtual_network_id" {
  type        = string
  description = "The ARM resource ID of the remote virtual network."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "allow_virtual_network_access" {
  type        = bool
  default     = true
  description = "Whether the VMs in the local VNet can access VMs in the remote VNet."
}

variable "allow_forwarded_traffic" {
  type        = bool
  default     = false
  description = "Whether forwarded traffic from VMs in the remote VNet is allowed."
}

variable "allow_gateway_transit" {
  type        = bool
  default     = false
  description = "Whether gateway links can be used in remote VNet to link to this VNet."
}

variable "use_remote_gateways" {
  type        = bool
  default     = false
  description = "Whether remote gateways can be used on this VNet."
}
