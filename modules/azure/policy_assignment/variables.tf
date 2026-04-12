# ── Scope ────────────────────────────────────────────────────────────────────

variable "scope" {
  type        = string
  description = <<-EOT
    The ARM resource ID of the scope for the policy assignment.
    Supported scopes:
      - Management group:  /providers/Microsoft.Management/managementGroups/{mgId}
      - Subscription:      /subscriptions/{subscriptionId}
      - Resource group:    /subscriptions/{subId}/resourceGroups/{rgName}
      - Resource:          /subscriptions/{subId}/resourceGroups/{rgName}/providers/{rp}/{type}/{name}
  EOT
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "assignment_name" {
  type        = string
  description = "The name of the policy assignment. Must be unique within the scope (max 24 chars for MG scope, 64 for others)."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "policy_definition_id" {
  type        = string
  description = <<-EOT
    The full ARM resource ID of the policy definition or policy set definition to assign.
    Examples:
      Built-in policy:     /providers/Microsoft.Authorization/policyDefinitions/{guid}
      Custom policy (MG):  /providers/Microsoft.Management/managementGroups/{mgId}/providers/Microsoft.Authorization/policyDefinitions/{name}
      Built-in initiative: /providers/Microsoft.Authorization/policySetDefinitions/{guid}
  EOT
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "display_name" {
  type        = string
  default     = null
  description = "The display name for the policy assignment."
}

variable "description" {
  type        = string
  default     = null
  description = "The description of the policy assignment."
}

variable "enforcement_mode" {
  type        = string
  default     = "Default"
  description = "The enforcement mode. Default: policy effect is enforced. DoNotEnforce: policy is evaluated but not enforced (audit-only). Allowed: Default, DoNotEnforce."

  validation {
    condition     = contains(["Default", "DoNotEnforce"], var.enforcement_mode)
    error_message = "enforcement_mode must be 'Default' or 'DoNotEnforce'."
  }
}

variable "parameters" {
  type        = any
  default     = null
  description = <<-EOT
    Parameter values for the policy assignment (map of parameter name → { value = ... }).
    Example:
      parameters = {
        tagName  = { value = "environment" }
        tagValue = { value = "production" }
      }
  EOT
}

variable "not_scopes" {
  type        = list(string)
  default     = []
  description = "List of ARM resource IDs that are excluded from the policy assignment scope."
}

variable "metadata" {
  type        = any
  default     = null
  description = "Metadata for the policy assignment (free-form object)."
}

variable "identity_type" {
  type        = string
  default     = "None"
  description = <<-EOT
    The managed identity type for the policy assignment.
    Required for policies with deployIfNotExists or modify effects.
    Allowed values: None, SystemAssigned, UserAssigned.
  EOT

  validation {
    condition     = contains(["None", "SystemAssigned", "UserAssigned"], var.identity_type)
    error_message = "identity_type must be 'None', 'SystemAssigned', or 'UserAssigned'."
  }
}

variable "identity_user_assigned_id" {
  type        = string
  default     = null
  description = "The full ARM resource ID of the user-assigned managed identity. Required when identity_type is UserAssigned."
}

variable "location" {
  type        = string
  default     = null
  description = "The location of the policy assignment. Required when identity_type is SystemAssigned or UserAssigned."
}

variable "non_compliance_messages" {
  type = list(object({
    message                        = string
    policy_definition_reference_id = optional(string, null)
  }))
  default     = []
  description = "Non-compliance messages shown to users when the policy denies a request or marks a resource as non-compliant."
}

# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it."
}

variable "auth_ref" {
  type        = string
  default     = null
  description = "Reference to a named_auth entry in the provider for cross-tenant auth."
}
