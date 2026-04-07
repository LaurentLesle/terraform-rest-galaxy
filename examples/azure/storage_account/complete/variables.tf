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
  description = "The name of the resource group in which to create the storage account."
}

variable "account_name" {
  type        = string
  description = "The name of the storage account (globally unique, 3–24 lowercase alphanumeric)."
}

variable "sku_name" {
  type        = string
  description = "The SKU name (e.g. Standard_LRS, Standard_GRS, Premium_LRS)."
}

variable "kind" {
  type        = string
  description = "The type of storage account (e.g. StorageV2, BlobStorage, FileStorage)."
}

variable "location" {
  type        = string
  description = "The Azure region for the storage account."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags to assign to the storage account."
}

variable "https_traffic_only_enabled" {
  type        = bool
  default     = true
  description = "Allow only HTTPS traffic to the storage service."
}

variable "minimum_tls_version" {
  type        = string
  default     = "TLS1_2"
  description = "Minimum TLS version (TLS1_0, TLS1_1, TLS1_2)."
}

variable "allow_blob_public_access" {
  type        = bool
  default     = false
  description = "Allow or disallow public access to all blobs or containers."
}

variable "allow_shared_key_access" {
  type        = bool
  default     = null
  description = "Whether the storage account permits Shared Key authorization."
}

variable "public_network_access" {
  type        = string
  default     = null
  description = "Control public network access (Enabled, Disabled, SecuredByPerimeter)."
}

variable "default_to_oauth_authentication" {
  type        = bool
  default     = null
  description = "Set the default authentication to OAuth/Entra ID."
}

variable "allow_cross_tenant_replication" {
  type        = bool
  default     = null
  description = "Allow or disallow cross-AAD-tenant object replication."
}
