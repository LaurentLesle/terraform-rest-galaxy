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

variable "network_manager_name" {
  type        = string
  description = "The name of the network manager."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "scope_subscriptions" {
  type        = list(string)
  default     = null
  description = "List of subscription resource IDs in the network manager scope. E.g. [\"/subscriptions/00000000-...\"]."
}

variable "scope_management_groups" {
  type        = list(string)
  default     = null
  description = "List of management group resource IDs in scope. E.g. [\"/Microsoft.Management/managementGroups/mg1\"]."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "description" {
  type        = string
  default     = null
  description = "A description of the network manager."
}

variable "scope_accesses" {
  type        = list(string)
  default     = null
  description = "Scope Access types. Valid values: SecurityAdmin, Connectivity, SecurityUser, Routing."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
