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
  description = "The actions to apply."
}

variable "conditions" {
  type = list(object({
    field    = string
    operator = string
    values   = list(string)
  }))
  default     = []
  description = "Conditions that narrow which alerts the rule applies to."
}

variable "schedule" {
  type = object({
    effective_from  = optional(string, null)
    effective_until = optional(string, null)
    time_zone       = optional(string, null)
    recurrences = optional(list(object({
      recurrence_type = string
      start_time      = optional(string, null)
      end_time        = optional(string, null)
      days_of_week    = optional(list(string), null)
      days_of_month   = optional(list(number), null)
    })), null)
  })
  default     = null
  description = "Schedule defining when the rule is active."
}

variable "description" {
  type        = string
  default     = null
  description = "Description of the rule."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Whether the rule is enabled."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the Alert Processing Rule."
}
