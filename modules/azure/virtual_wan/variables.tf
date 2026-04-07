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

variable "virtual_wan_name" {
  type        = string
  default     = null
  description = "The name of the Virtual WAN."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region for the Virtual WAN."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "type" {
  type        = string
  default     = "Standard"
  description = "The type of the VirtualWAN (Basic or Standard)."
}

variable "disable_vpn_encryption" {
  type        = bool
  default     = null
  description = "Vpn encryption to be disabled or not."
}

variable "allow_branch_to_branch_traffic" {
  type        = bool
  default     = null
  description = "True if branch to branch traffic is allowed."
}

variable "allow_vnet_to_vnet_traffic" {
  type        = bool
  default     = null
  description = "True if Vnet to Vnet traffic is allowed."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
