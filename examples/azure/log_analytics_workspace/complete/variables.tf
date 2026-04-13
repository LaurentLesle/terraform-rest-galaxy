variable "id_token" {
  type        = string
  sensitive   = true
  default     = null
  description = "GitHub Actions OIDC JWT. Required when access_token is not set."
}

variable "tenant_id" {
  type        = string
  default     = null
  description = "The Azure tenant ID."
}

variable "client_id" {
  type        = string
  default     = null
  description = "The Azure app registration client ID."
}

variable "access_token" {
  type        = string
  sensitive   = true
  default     = null
  description = "Direct Azure access token for local dev."
}

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "workspace_name" {
  type        = string
  description = "The name of the Log Analytics Workspace."
}

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "sku_name" {
  type        = string
  default     = "PerGB2018"
  description = "The SKU of the workspace."
}

variable "retention_in_days" {
  type        = number
  default     = 90
  description = "Data retention in days."
}

variable "daily_quota_gb" {
  type        = number
  default     = null
  description = "Daily quota for ingestion in GB (-1 = unlimited)."
}

variable "public_network_access_for_ingestion" {
  type        = string
  default     = "Enabled"
  description = "Network access type for ingestion."
}

variable "public_network_access_for_query" {
  type        = string
  default     = "Enabled"
  description = "Network access type for query."
}

variable "features_disable_local_auth" {
  type        = bool
  default     = true
  description = "Disable Non-AAD based Auth."
}

variable "features_enable_data_export" {
  type        = bool
  default     = null
  description = "Flag that indicates if data should be exported."
}

variable "features_enable_log_access_using_only_resource_permissions" {
  type        = bool
  default     = null
  description = "Flag that indicates which permission to use."
}

variable "identity_type" {
  type        = string
  default     = null
  description = "The type of managed identity (SystemAssigned, UserAssigned, None)."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}
