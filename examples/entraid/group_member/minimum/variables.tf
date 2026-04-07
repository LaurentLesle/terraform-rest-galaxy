# ── Authentication — Option A: OIDC (GitHub Actions CI) ──────────────────────

variable "id_token" {
  type        = string
  sensitive   = true
  default     = null
  description = "GitHub Actions OIDC JWT."
}

variable "tenant_id" {
  type        = string
  default     = null
  description = "The Azure tenant ID."
}

variable "client_id" {
  type        = string
  default     = null
  description = "The Azure app registration client ID (federated credential)."
}

# ── Authentication — Option B: Direct tokens (local dev) ─────────────────────

variable "access_token" {
  type        = string
  sensitive   = true
  default     = "placeholder"
  description = "Azure ARM access token."
}

variable "graph_access_token" {
  type      = string
  sensitive = true
  default   = null
}

variable "user_principal_name" {
  type        = string
  description = "UPN for the test user."
}

variable "password" {
  type        = string
  sensitive   = true
  description = "Password for the test user."
}
