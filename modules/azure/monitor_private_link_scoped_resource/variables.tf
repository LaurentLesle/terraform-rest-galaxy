# ── Provider behaviour ──────────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists."
}

# ── Scope ───────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID in which the scoped resource association is created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the Azure Monitor Private Link Scope."
}

variable "private_link_scope_name" {
  type        = string
  description = "The name of the Azure Monitor Private Link Scope to which the resource is associated."
}

# ── Identity ────────────────────────────────────────────────────────────────────

variable "scoped_resource_name" {
  type        = string
  description = "The name of the scoped resource association. Must be unique within the private link scope."

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9._-]{0,253}[a-zA-Z0-9]$|^[a-zA-Z0-9]$", var.scoped_resource_name))
    error_message = "scoped_resource_name must be 1-255 characters, start and end with an alphanumeric character, and contain only letters, digits, hyphens, underscores, and periods."
  }
}

# ── Required body properties ────────────────────────────────────────────────────

variable "linked_resource_id" {
  type        = string
  description = "The ARM resource ID of the Azure Monitor resource (Log Analytics Workspace, Data Collection Endpoint, Monitor Workspace, etc.) to link into the private link scope."
}
