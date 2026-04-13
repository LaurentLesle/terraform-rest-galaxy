# ── Provider behaviour ──────────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists."
}

# ── Scope ───────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID in which the Azure Monitor Workspace is created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the Azure Monitor Workspace."
}

# ── Identity ────────────────────────────────────────────────────────────────────

variable "monitor_workspace_name" {
  type        = string
  default     = null
  description = "The name of the Azure Monitor Workspace. Must match pattern ^(?!-)[a-zA-Z0-9-]+[^-]$. When null, the for_each key is used."

  validation {
    condition     = var.monitor_workspace_name == null || can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]{2,48}[a-zA-Z0-9]$", var.monitor_workspace_name))
    error_message = "monitor_workspace_name must be 4–50 characters, start and end with an alphanumeric character, and contain only letters, digits, and hyphens."
  }
}

# ── Required body properties ────────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The geo-location where the Azure Monitor Workspace lives."
}

# ── Optional body properties ────────────────────────────────────────────────────

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
