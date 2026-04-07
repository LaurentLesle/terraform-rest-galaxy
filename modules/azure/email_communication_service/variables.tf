# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows."
}

# ── Scope ────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID in which the Email Communication Service is created."
}

# ── Parent scope ──────────────────────────────────────────────────────────────

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Email Communication Service."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "email_service_name" {
  type        = string
  description = "The name of the Email Communication Service resource."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The geo-location where the resource lives. Typically 'global' for Email Communication Services."
}

variable "data_location" {
  type        = string
  description = "The location where the Email Communication Service stores its data at rest (e.g. 'Europe', 'United States', 'Asia Pacific', 'Australia', 'UK', 'Japan', 'South Korea', 'Brazil', 'Africa')."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags to assign to the Email Communication Service."
}
