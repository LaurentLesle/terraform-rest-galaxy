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

variable "activity_log_alert_name" {
  type        = string
  description = "The name of the Activity Log Alert."
}

variable "scopes" {
  type        = list(string)
  description = "The list of resource ARM IDs that the alert applies to (e.g. subscription IDs)."
}

variable "condition" {
  type = object({
    all_of = list(object({
      field        = optional(string, null)
      equals       = optional(string, null)
      contains_any = optional(list(string), null)
      any_of = optional(list(object({
        field  = optional(string, null)
        equals = optional(string, null)
      })), null)
    }))
  })
  description = "The condition that triggers the alert."
}

variable "actions" {
  type = object({
    action_groups = optional(list(object({
      action_group_id    = string
      webhook_properties = optional(map(string), null)
    })), [])
  })
  description = "The actions to take when the alert triggers."
}
