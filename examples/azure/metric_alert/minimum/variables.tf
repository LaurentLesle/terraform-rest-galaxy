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

variable "metric_alert_name" {
  type        = string
  description = "The name of the Metric Alert."
}

variable "severity" {
  type        = number
  description = "The severity of the alert (0=Critical, 1=Error, 2=Warning, 3=Informational, 4=Verbose)."
}

variable "scopes" {
  type        = list(string)
  description = "The list of resource ARM IDs that the alert applies to."
}

variable "evaluation_frequency" {
  type        = string
  description = "How often the metric alert is evaluated. ISO 8601 duration (e.g. PT5M)."
}

variable "criteria" {
  type        = any
  description = "The criteria that define when the alert triggers."
}
