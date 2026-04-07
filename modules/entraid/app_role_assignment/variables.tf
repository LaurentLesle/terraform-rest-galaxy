# ── Required ──────────────────────────────────────────────────────────────────

variable "resource_app_id" {
  type        = string
  description = "The application (client) ID of the Enterprise Application (e.g. the Azure VPN app ID). The module looks up the service principal object ID automatically."
}

variable "principal_id" {
  type        = string
  description = "The object ID of the user, group, or service principal to assign to the Enterprise Application."
}

# ── Optional ─────────────────────────────────────────────────────────────────

variable "app_role_id" {
  type        = string
  default     = "00000000-0000-0000-0000-000000000000"
  description = "The app role ID to assign. Use the default zero GUID for the default access role."
}

variable "principal_type" {
  type        = string
  default     = null
  description = "The type of the principal. Possible values: User, Group, ServicePrincipal. Read-only in the API but useful for documentation."
}
