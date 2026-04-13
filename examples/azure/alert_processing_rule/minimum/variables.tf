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

variable "alert_processing_rule_name" {
  type        = string
  description = "The name of the Alert Processing Rule."
}

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "scopes" {
  type        = list(string)
  description = "The list of resource ARM IDs that the rule applies to."
}

variable "actions" {
  type = list(object({
    action_type      = string
    action_group_ids = optional(list(string), null)
  }))
  description = "The list of actions to apply. Use action_type = 'RemoveAllActionGroups' to suppress alerts or 'AddActionGroups' to route them."
}
