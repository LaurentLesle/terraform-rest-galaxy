# ── Authentication — Option A: OIDC (GitHub Actions CI) ──────────────────────

variable "id_token" {
  type        = string
  sensitive   = true
  default     = null
  description = "GitHub Actions OIDC JWT. Required when graph_access_token is not set."
}

variable "tenant_id" {
  type        = string
  default     = null
  description = "The Azure tenant ID. Required when graph_access_token is not set."
}

variable "client_id" {
  type        = string
  default     = null
  description = "The Azure app registration client ID (federated credential). Required when graph_access_token is not set."
}

# ── Authentication — Option B: Direct tokens (local dev) ─────────────────────

variable "access_token" {
  type        = string
  sensitive   = true
  default     = "placeholder"
  description = "Azure ARM access token. Not used by users but required by root module."
}

variable "graph_access_token" {
  type        = string
  sensitive   = true
  default     = null
  description = "Microsoft Graph access token for local dev. Get via: az account get-access-token --resource https://graph.microsoft.com --query accessToken -o tsv"
}

# ── Module inputs ─────────────────────────────────────────────────────────────

variable "display_name" {
  type        = string
  description = "The display name for the user."
}

variable "mail_nickname" {
  type        = string
  description = "The mail alias for the user."
}

variable "user_principal_name" {
  type        = string
  description = "The UPN for the user."
}

variable "password" {
  type        = string
  sensitive   = true
  description = "The initial password for the user."
}
