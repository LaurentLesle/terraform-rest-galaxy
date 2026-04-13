# ── Scope ────────────────────────────────────────────────────────────────────

variable "scope" {
  type        = string
  description = <<-EOT
    The scope at which the policy definition is created.
    - Subscription scope: /subscriptions/{subscriptionId}
    - Management group scope: /providers/Microsoft.Management/managementGroups/{managementGroupId}
  EOT
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "policy_definition_name" {
  type        = string
  description = "The name of the policy definition. Must be unique within the scope."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "policy_type" {
  type        = string
  default     = "Custom"
  description = "The type of policy definition. Allowed values: BuiltIn, Custom, NotSpecified, Static."

  validation {
    condition     = contains(["BuiltIn", "Custom", "NotSpecified", "Static"], var.policy_type)
    error_message = "policy_type must be one of: BuiltIn, Custom, NotSpecified, Static."
  }
}

variable "mode" {
  type        = string
  default     = "All"
  description = <<-EOT
    The policy mode. Determines which resource types are evaluated.
    Common values: All, Indexed, Microsoft.KeyVault.Data, Microsoft.ContainerService.Data
  EOT
}

variable "display_name" {
  type        = string
  description = "The display name of the policy definition."
}

variable "policy_rule" {
  type        = any
  description = <<-EOT
    The policy rule object (if/then logic). Must match the ARM policy rule schema.
    Example:
      policy_rule = {
        if   = { field = "location", notIn = ["westeurope", "northeurope"] }
        then = { effect = "Deny" }
      }
  EOT
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "description" {
  type        = string
  default     = null
  description = "The description of the policy definition."
}

variable "metadata" {
  type        = any
  default     = null
  description = "The metadata for the policy definition (free-form object, e.g. category, version)."
}

variable "parameters" {
  type        = any
  default     = null
  description = "The parameters for the policy definition (map of parameter objects with type, defaultValue, allowedValues, metadata)."
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
