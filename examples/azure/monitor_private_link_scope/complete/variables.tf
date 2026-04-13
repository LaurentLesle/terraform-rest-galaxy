# ── Authentication — Option A: OIDC (GitHub Actions CI) ──────────────────────

variable "id_token" {
  type        = string
  sensitive   = true
  default     = null
  description = "GitHub Actions OIDC JWT (TF_VAR_id_token=$ACTIONS_ID_TOKEN_REQUEST_TOKEN). Required when access_token is not set."
}

variable "tenant_id" {
  type        = string
  default     = null
  description = "The Azure tenant ID. Required when access_token is not set."
}

variable "client_id" {
  type        = string
  default     = null
  description = "The Azure app registration client ID (federated credential). Required when access_token is not set."
}

# ── Authentication — Option B: Direct token (local dev) ──────────────────────

variable "access_token" {
  type        = string
  sensitive   = true
  default     = null
  description = "Direct Azure access token for local dev (skips OIDC exchange). Get via: source .github/scripts/get-dev-token.sh"
}

# ── Module inputs ─────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group that contains the AMPLS."
}

variable "scope_name" {
  type        = string
  description = "The name of the Azure Monitor Private Link Scope."
}

variable "location" {
  type        = string
  description = "The Azure region for the AMPLS."
}

variable "ingestion_access_mode" {
  type        = string
  default     = "PrivateOnly"
  description = "The default access mode for ingestion through associated private endpoints. Allowed values: 'Open', 'PrivateOnly'."
}

variable "query_access_mode" {
  type        = string
  default     = "PrivateOnly"
  description = "The default access mode for queries through associated private endpoints. Allowed values: 'Open', 'PrivateOnly'."
}

variable "access_mode_exclusions" {
  type = list(object({
    privateEndpointConnectionName = string
    privateEndpointResourceId     = string
    ingestionAccessMode           = optional(string, null)
    queryAccessMode               = optional(string, null)
  }))
  default     = []
  description = "List of exclusions that override the default access mode settings for specific private endpoint connections."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
