# ── Authentication ────────────────────────────────────────────────────────────

variable "access_token" {
  type        = string
  sensitive   = true
  default     = null
  description = "Azure access token (local dev). Takes precedence over OIDC."
}

variable "id_token" {
  type        = string
  sensitive   = true
  default     = null
  description = "GitHub Actions OIDC JWT for token exchange."
}

variable "client_id" {
  type        = string
  default     = null
  description = "Service principal client ID for OIDC exchange."
}

variable "tenant_id" {
  type        = string
  default     = null
  description = "Azure AD tenant ID for OIDC exchange."
}

variable "subscription_id" {
  type        = string
  default     = null
  description = "Not used directly but required by root module variable."
}

# ── Resource ──────────────────────────────────────────────────────────────────

variable "root_management_group_id" {
  type        = string
  description = "The management group ID for the root group (e.g. 'mg-contoso-root')."
}

variable "root_display_name" {
  type        = string
  default     = "Contoso Root"
  description = "Display name for the root management group."
}
