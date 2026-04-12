# ── Provider behaviour ──────────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists."
}

# ── Scope ───────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID in which the Azure Monitor Private Link Scope is created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the Azure Monitor Private Link Scope."
}

# ── Identity ────────────────────────────────────────────────────────────────────

variable "scope_name" {
  type        = string
  default     = null
  description = "The name of the Azure Monitor Private Link Scope. Must be 1–255 characters. When null, the for_each key is used."

  validation {
    condition     = var.scope_name == null || can(regex("^[a-zA-Z0-9][a-zA-Z0-9._-]{0,253}[a-zA-Z0-9]$|^[a-zA-Z0-9]$", var.scope_name))
    error_message = "scope_name must be 1-255 characters, start and end with an alphanumeric character, and contain only letters, digits, hyphens, underscores, and periods."
  }
}

# ── Required body properties ────────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The geo-location where the Azure Monitor Private Link Scope lives."
}

variable "ingestion_access_mode" {
  type        = string
  default     = "PrivateOnly"
  description = "The default access mode for ingestion through associated private endpoints. Allowed values: 'Open', 'PrivateOnly'. Defaults to 'PrivateOnly' for security compliance."

  validation {
    condition     = var.ingestion_access_mode == null || contains(["Open", "PrivateOnly"], var.ingestion_access_mode)
    error_message = "ingestion_access_mode must be 'Open' or 'PrivateOnly'."
  }
}

variable "query_access_mode" {
  type        = string
  default     = "PrivateOnly"
  description = "The default access mode for queries through associated private endpoints. Allowed values: 'Open', 'PrivateOnly'. Defaults to 'PrivateOnly' for security compliance."

  validation {
    condition     = var.query_access_mode == null || contains(["Open", "PrivateOnly"], var.query_access_mode)
    error_message = "query_access_mode must be 'Open' or 'PrivateOnly'."
  }
}

# ── Optional body properties ────────────────────────────────────────────────────

variable "access_mode_exclusions" {
  type = list(object({
    privateEndpointConnectionName = string
    privateEndpointResourceId     = string
    ingestionAccessMode           = optional(string, null)
    queryAccessMode               = optional(string, null)
  }))
  default     = []
  description = "List of exclusions that override the default access mode settings for specific private endpoint connections."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
