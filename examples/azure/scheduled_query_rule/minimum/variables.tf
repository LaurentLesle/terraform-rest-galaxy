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
  description = "The list of resource ARM IDs that the rule applies to (e.g. Log Analytics workspace IDs)."
}

variable "severity" {
  type        = number
  description = "The severity of the alert (0=Critical, 1=Error, 2=Warning, 3=Informational, 4=Verbose)."
}

variable "evaluation_frequency" {
  type        = string
  description = "How often the rule is evaluated. ISO 8601 duration (e.g. PT15M)."
}

variable "window_size" {
  type        = string
  description = "The period of time on which the alert query is executed. ISO 8601 duration (e.g. PT15M)."
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
