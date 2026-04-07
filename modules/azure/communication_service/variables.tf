# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows."
}

# ── Scope ────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID in which the Communication Service is created."
}

# ── Parent scope ──────────────────────────────────────────────────────────────

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Communication Service."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "communication_service_name" {
  type        = string
  description = "The name of the Communication Service resource. Globally unique."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The geo-location where the resource lives. Typically 'global' for Communication Services."
}

variable "data_location" {
  type        = string
  description = "The location where the Communication Service stores its data at rest (e.g. 'Europe', 'United States', 'Asia Pacific', 'Australia', 'UK', 'Japan', 'South Korea', 'Brazil', 'Africa')."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "linked_domains" {
  type        = list(string)
  default     = null
  description = "List of email domain resource IDs to link to this Communication Service."
}

variable "public_network_access" {
  type        = string
  default     = null
  description = "Control public network access. Options: Enabled, Disabled, SecuredByPerimeter."
}

variable "disable_local_auth" {
  type        = bool
  default     = null
  description = "Disable local authentication for the Communication Service."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags to assign to the Communication Service."
}
