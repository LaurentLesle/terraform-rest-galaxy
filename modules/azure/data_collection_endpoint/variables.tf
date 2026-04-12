# ── Provider behaviour ──────────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists."
}

# ── Scope ───────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID in which the Data Collection Endpoint is created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the Data Collection Endpoint."
}

# ── Identity ────────────────────────────────────────────────────────────────────

variable "data_collection_endpoint_name" {
  type        = string
  description = "The name of the Data Collection Endpoint."
}

# ── Required body properties ────────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The geo-location where the Data Collection Endpoint lives."
}

# ── Optional body properties ────────────────────────────────────────────────────

variable "description" {
  type        = string
  default     = null
  description = "Description of the data collection endpoint."
}

variable "public_network_access" {
  type        = string
  default     = "Enabled"
  description = "The configuration to set whether network access from public internet to the endpoints are allowed. Allowed values: Enabled, Disabled, SecuredByPerimeter."

  validation {
    condition     = contains(["Enabled", "Disabled", "SecuredByPerimeter"], var.public_network_access)
    error_message = "public_network_access must be one of: Enabled, Disabled, SecuredByPerimeter."
  }
}

variable "kind" {
  type        = string
  default     = null
  description = "The kind of the resource. Typically 'Linux' or 'Windows'."
}

variable "identity_type" {
  type        = string
  default     = null
  description = "The type of managed identity. Allowed values: SystemAssigned, UserAssigned, SystemAssigned+UserAssigned, None."

  validation {
    condition     = var.identity_type == null || contains(["SystemAssigned", "UserAssigned", "SystemAssigned,UserAssigned", "None"], var.identity_type)
    error_message = "identity_type must be one of: SystemAssigned, UserAssigned, SystemAssigned,UserAssigned, None."
  }
}

variable "identity_user_assigned_identity_ids" {
  type        = list(string)
  default     = null
  description = "List of user-assigned identity resource IDs. Required when identity_type includes UserAssigned."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
