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

variable "routing_intent_name" {
  type        = string
  default     = "RoutingIntent"
  description = "The name of the Routing Intent resource (singleton per hub)."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "firewall_id" {
  type        = string
  description = "The ARM resource ID of the Azure Firewall used as nextHop for routing policies."
}

# ── Routing policies ─────────────────────────────────────────────────────────

variable "internet_traffic" {
  type        = bool
  default     = true
  description = "Route Internet traffic through the firewall."
}

variable "private_traffic" {
  type        = bool
  default     = true
  description = "Route private (RFC1918) traffic through the firewall."
}
