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

variable "action_group_name" {
  type        = string
  description = "The name of the Action Group."
}

variable "short_name" {
  type        = string
  description = "The short name of the Action Group (max 12 characters)."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Whether the Action Group is enabled."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply to the Action Group."
}

variable "email_receivers" {
  type = list(object({
    name                    = string
    email_address           = string
    use_common_alert_schema = optional(bool, true)
  }))
  default     = []
  description = "List of email receivers."
}

variable "sms_receivers" {
  type = list(object({
    name         = string
    country_code = string
    phone_number = string
  }))
  default     = []
  description = "List of SMS receivers."
}

variable "webhook_receivers" {
  type = list(object({
    name                    = string
    service_uri             = string
    use_common_alert_schema = optional(bool, true)
    use_aad_auth            = optional(bool, false)
    object_id               = optional(string, null)
    identifier_uri          = optional(string, null)
    tenant_id               = optional(string, null)
  }))
  default     = []
  description = "List of webhook receivers."
}

variable "arm_role_receivers" {
  type = list(object({
    name                    = string
    role_id                 = string
    use_common_alert_schema = optional(bool, true)
  }))
  default     = []
  description = "List of ARM role receivers."
}
