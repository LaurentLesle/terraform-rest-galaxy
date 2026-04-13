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

variable "resource_id" {
  type        = string
  description = "The full ARM resource ID of the target resource to associate with the Data Collection Rule."
}

variable "association_name" {
  type        = string
  default     = null
  description = "The name of the Data Collection Rule Association."
}

variable "description" {
  type        = string
  default     = null
  description = "Description of the association."
}

variable "data_collection_rule_id" {
  type        = string
  default     = null
  description = "The full ARM resource ID of the Data Collection Rule to associate."
}
