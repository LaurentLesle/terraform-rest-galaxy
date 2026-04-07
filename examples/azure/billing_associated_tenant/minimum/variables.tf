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

# ── Resource ─────────────────────────────────────────────────────────────────

variable "billing_account_name" {
  type        = string
  description = "The billing account ID."
}

variable "associated_tenant_id" {
  type        = string
  description = "The tenant ID (GUID) to associate with the billing account."
}

variable "display_name" {
  type        = string
  description = "A friendly name for the associated tenant."
}

variable "billing_management_state" {
  type        = string
  default     = "Active"
  description = "Billing management access. One of: Active, NotAllowed, Revoked."
}

variable "provisioning_management_state" {
  type        = string
  default     = "NotRequested"
  description = "Provisioning access. One of: Active, NotRequested, Pending."
}
