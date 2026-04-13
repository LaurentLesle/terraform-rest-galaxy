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
  description = "The severity (0=Critical, 1=Error, 2=Warning, 3=Informational, 4=Verbose)."
}

variable "scopes" {
  type        = list(string)
  description = "The list of resource ARM IDs the alert applies to."
}

variable "evaluation_frequency" {
  type        = string
  description = "How often the metric alert is evaluated. ISO 8601 duration (e.g. PT5M)."
}

variable "criteria" {
  type        = any
  description = "The criteria defining when the alert triggers."
}

variable "description" {
  type        = string
  default     = null
  description = "Description of the alert."
}

variable "window_size" {
  type        = string
  default     = null
  description = "The period of time monitored for each evaluation. ISO 8601 duration (e.g. PT15M)."
}

variable "auto_mitigate" {
  type        = bool
  default     = true
  description = "Whether the alert is auto-resolved once the condition is no longer met."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Whether the metric alert is enabled."
}

variable "actions" {
  type = list(object({
    action_group_id    = string
    webhook_properties = optional(map(string), null)
  }))
  default     = []
  description = "List of action groups to trigger when the alert fires."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the Metric Alert."
}
