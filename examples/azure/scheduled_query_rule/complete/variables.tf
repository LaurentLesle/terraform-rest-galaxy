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

variable "rule_name" {
  type        = string
  description = "The name of the Scheduled Query Rule."
}

variable "location" {
  type        = string
  description = "The Azure region."
}

variable "scopes" {
  type        = list(string)
  description = "The list of resource ARM IDs the rule applies to."
}

variable "severity" {
  type        = number
  description = "The severity (0=Critical, 1=Error, 2=Warning, 3=Informational, 4=Verbose)."
}

variable "evaluation_frequency" {
  type        = string
  description = "How often the rule is evaluated. ISO 8601 duration (e.g. PT15M)."
}

variable "window_size" {
  type        = string
  description = "The period of time on which the alert query is executed. ISO 8601 duration."
}

variable "criteria" {
  type = object({
    all_of = list(object({
      query                 = optional(string, null)
      time_aggregation      = optional(string, null)
      metric_measure_column = optional(string, null)
      resource_id_column    = optional(string, null)
      operator              = optional(string, null)
      threshold             = optional(number, null)
      failing_periods = optional(object({
        number_of_evaluation_periods = number
        min_failing_periods_to_alert = number
      }), null)
      dimensions = optional(list(object({
        name     = string
        operator = string
        values   = list(string)
      })), null)
    }))
  })
  description = "The criteria that define when the alert triggers."
}

variable "description" {
  type        = string
  default     = null
  description = "Description of the rule."
}

variable "display_name" {
  type        = string
  default     = null
  description = "Display name of the alert rule."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Whether the rule is enabled."
}

variable "auto_mitigate" {
  type        = bool
  default     = true
  description = "Whether the alert is auto-resolved when the condition is no longer met."
}

variable "mute_actions_duration" {
  type        = string
  default     = null
  description = "Mute actions for the chosen period after the alert is fired. ISO 8601 duration (e.g. PT30M)."
}

variable "actions" {
  type = object({
    action_groups     = optional(list(string), [])
    custom_properties = optional(map(string), null)
    action_properties = optional(map(string), null)
  })
  default     = null
  description = "Actions to take when the rule fires."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the Scheduled Query Rule."
}
