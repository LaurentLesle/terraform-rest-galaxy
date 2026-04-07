# ── Required ──────────────────────────────────────────────────────────────────

variable "client_id" {
  type        = string
  description = "The object ID of the client service principal (the app that is granted consent)."
}

variable "resource_id" {
  type        = string
  description = "The object ID of the resource service principal (the API being consented to)."
}

# ── Optional ─────────────────────────────────────────────────────────────────

variable "scope" {
  type        = string
  default     = "user_impersonation"
  description = "Space-delimited list of delegated permission scopes to grant."
}

variable "consent_type" {
  type        = string
  default     = "AllPrincipals"
  description = "Indicates whether consent is granted for all principals or a specific principal. Values: AllPrincipals, Principal."
}

variable "principal_id" {
  type        = string
  default     = null
  description = "The object ID of the user/principal when consent_type is 'Principal'. Required only for principal-specific consent."
}

variable "start_time" {
  type        = string
  default     = "2024-01-01T00:00:00Z"
  description = "Required by /beta API but currently ignored by the service. Use any past ISO 8601 date."
}

variable "expiry_time" {
  type        = string
  default     = "2299-12-31T00:00:00Z"
  description = "Required by /beta API but currently ignored by the service. Use a far-future ISO 8601 date."
}
