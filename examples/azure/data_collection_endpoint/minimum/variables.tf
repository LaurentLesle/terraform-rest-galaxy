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

variable "data_collection_endpoint_name" {
  type        = string
  description = "The name of the Data Collection Endpoint."
}

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "public_network_access" {
  type        = string
  default     = "Enabled"
  description = "Network access for ingestion (Enabled or Disabled)."
}
