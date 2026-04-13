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
  description = "The name of the resource group containing the Private DNS Zone."
}

variable "private_dns_zone_name" {
  type        = string
  description = "The name of the Private DNS Zone (e.g. 'privatelink.monitor.azure.com')."
}

variable "virtual_network_link_name" {
  type        = string
  description = "The name of the virtual network link."
}

variable "virtual_network_id" {
  type        = string
  description = "The ARM resource ID of the virtual network to link."
}

variable "registration_enabled" {
  type        = bool
  default     = false
  description = "Is auto-registration of virtual machine records in the virtual network in the Private DNS zone enabled?"
}

variable "resolution_policy" {
  type        = string
  default     = null
  description = "The resolution policy on the virtual network link. Allowed values: 'Default', 'NxDomainRedirect'."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
