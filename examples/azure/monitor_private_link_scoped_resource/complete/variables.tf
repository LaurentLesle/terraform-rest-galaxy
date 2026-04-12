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

variable "private_link_scope_name" {
  type        = string
  description = "The name of the Azure Monitor Private Link Scope."
}

variable "scoped_resource_name_law" {
  type        = string
  default     = "link-law"
  description = "Name for the Log Analytics Workspace scoped resource association."
}

variable "linked_resource_id_law" {
  type        = string
  description = "The ARM resource ID of the Log Analytics Workspace to link into the AMPLS."
}

variable "scoped_resource_name_dce" {
  type        = string
  default     = "link-dce"
  description = "Name for the Data Collection Endpoint scoped resource association."
}

variable "linked_resource_id_dce" {
  type        = string
  description = "The ARM resource ID of the Data Collection Endpoint to link into the AMPLS."
}
