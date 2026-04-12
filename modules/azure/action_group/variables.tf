# Source: azure-rest-api-specs
#   spec_path  : monitor/resource-manager/Microsoft.Insights/Insights
#   api_version: 2023-01-01
#   swagger    : actionGroups_API.json

# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it."
}

# ── Scope ──────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID in which the action group is created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

# ── Resource identity ──────────────────────────────────────────────────────

variable "action_group_name" {
  type        = string
  description = "The name of the action group."
}

variable "location" {
  type        = string
  default     = "global"
  description = "Resource location. Action groups are typically created in 'global'."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags."
}

# ── Required properties ────────────────────────────────────────────────────

variable "short_name" {
  type        = string
  description = "The short name of the action group (max 12 characters). Used in SMS messages."

  validation {
    condition     = var.short_name == null || can(regex("^.{1,12}$", var.short_name))
    error_message = "short_name must be between 1 and 12 characters."
  }
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Indicates whether this action group is enabled."
}

# ── Email receivers ────────────────────────────────────────────────────────

variable "email_receivers" {
  type = list(object({
    name                  = string
    email_address         = string
    use_common_alert_schema = optional(bool, true)
  }))
  default     = []
  description = "List of email receivers."
}

# ── SMS receivers ──────────────────────────────────────────────────────────

variable "sms_receivers" {
  type = list(object({
    name         = string
    country_code = string
    phone_number = string
  }))
  default     = []
  description = "List of SMS receivers."
}

# ── Webhook receivers ──────────────────────────────────────────────────────

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

# ── ITSM receivers ─────────────────────────────────────────────────────────

variable "itsm_receivers" {
  type = list(object({
    name                 = string
    workspace_id         = string
    connection_id        = string
    ticket_configuration = string
    region               = string
  }))
  default     = []
  description = "List of ITSM receivers."
}

# ── Azure App Push receivers ───────────────────────────────────────────────

variable "azure_app_push_receivers" {
  type = list(object({
    name          = string
    email_address = string
  }))
  default     = []
  description = "List of Azure mobile app push notification receivers."
}

# ── Automation Runbook receivers ───────────────────────────────────────────

variable "automation_runbook_receivers" {
  type = list(object({
    name                    = string
    automation_account_id   = string
    runbook_name            = string
    webhook_resource_id     = string
    is_global_runbook       = bool
    service_uri             = optional(string, null)
    use_common_alert_schema = optional(bool, true)
  }))
  default     = []
  description = "List of Automation Runbook receivers."
}

# ── Voice receivers ────────────────────────────────────────────────────────

variable "voice_receivers" {
  type = list(object({
    name         = string
    country_code = string
    phone_number = string
  }))
  default     = []
  description = "List of voice receivers."
}

# ── Logic App receivers ────────────────────────────────────────────────────

variable "logic_app_receivers" {
  type = list(object({
    name                    = string
    resource_id             = string
    callback_url            = string
    use_common_alert_schema = optional(bool, true)
  }))
  default     = []
  description = "List of Logic App receivers."
}

# ── Azure Function receivers ───────────────────────────────────────────────

variable "azure_function_receivers" {
  type = list(object({
    name                     = string
    function_app_resource_id = string
    function_name            = string
    http_trigger_url         = string
    use_common_alert_schema  = optional(bool, true)
  }))
  default     = []
  description = "List of Azure Function receivers."
}

# ── ARM Role receivers ─────────────────────────────────────────────────────

variable "arm_role_receivers" {
  type = list(object({
    name                    = string
    role_id                 = string
    use_common_alert_schema = optional(bool, true)
  }))
  default     = []
  description = "List of ARM role receivers. Roles are Azure RBAC roles; only built-in roles are supported."
}

# ── Event Hub receivers ────────────────────────────────────────────────────

variable "event_hub_receivers" {
  type = list(object({
    name                    = string
    event_hub_namespace     = string
    event_hub_name          = string
    subscription_id         = string
    tenant_id               = optional(string, null)
    use_common_alert_schema = optional(bool, true)
  }))
  default     = []
  description = "List of Event Hub receivers."
}
