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

variable "application_insights_name" {
  type        = string
  description = "The name of the Application Insights component."
}

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "kind" {
  type        = string
  default     = "web"
  description = "The kind of application (web, ios, other, store, java, phone)."
}

variable "application_type" {
  type        = string
  default     = "web"
  description = "Type of application being monitored (web or other)."
}
