# ── Scope ────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID."
}

# ── Required ──────────────────────────────────────────────────────────────────

variable "provider_namespace" {
  type        = string
  description = "The resource provider namespace (e.g. Microsoft.Compute)."
}

variable "feature_name" {
  type        = string
  description = "The name of the feature to register (e.g. EncryptionAtHost)."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "state" {
  type        = string
  default     = "Registered"
  description = "The desired registration state. Defaults to 'Registered'."
}

variable "metadata" {
  type        = map(string)
  default     = null
  description = "Key-value pairs for metadata."
}

variable "description" {
  type        = string
  default     = null
  description = "The feature description."
}

variable "should_feature_display_in_portal" {
  type        = bool
  default     = null
  description = "Indicates whether the feature should be displayed in the Portal."
}

# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows."
}
