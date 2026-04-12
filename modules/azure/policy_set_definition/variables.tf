# ── Scope ────────────────────────────────────────────────────────────────────

variable "scope" {
  type        = string
  description = <<-EOT
    The scope at which the policy set definition (initiative) is created.
    - Subscription scope:       /subscriptions/{subscriptionId}
    - Management group scope:   /providers/Microsoft.Management/managementGroups/{managementGroupId}
  EOT
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "policy_set_definition_name" {
  type        = string
  description = "The name of the policy set definition. Must be unique within the scope."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "policy_type" {
  type        = string
  default     = "Custom"
  description = "The type of policy set definition. Allowed values: BuiltIn, Custom, NotSpecified."

  validation {
    condition     = contains(["BuiltIn", "Custom", "NotSpecified"], var.policy_type)
    error_message = "policy_type must be one of: BuiltIn, Custom, NotSpecified."
  }
}

variable "display_name" {
  type        = string
  description = "The display name of the policy set definition (initiative)."
}

variable "policy_definitions" {
  type = any
  description = <<-EOT
    List of policy definition references included in this initiative.
    Each entry requires at minimum a policy_definition_id (full ARM ID).
    Example:
      policy_definitions = [
        {
          policy_definition_id           = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-..."
          policy_definition_reference_id = "require_tags"
          parameters = {
            tagName  = { value = "[parameters('tagName')]" }
            tagValue = { value = "[parameters('tagValue')]" }
          }
        }
      ]
  EOT
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "description" {
  type        = string
  default     = null
  description = "The description of the policy set definition."
}

variable "metadata" {
  type        = any
  default     = null
  description = "Metadata for the policy set definition (e.g. category, version)."
}

variable "parameters" {
  type        = any
  default     = null
  description = "Parameters for the initiative (map of parameter definitions). Allows child policies to be parameterised at assignment time."
}

variable "policy_definition_groups" {
  type = list(object({
    name                = string
    display_name        = optional(string, null)
    description         = optional(string, null)
    additional_metadata = optional(any, null)
  }))
  default     = []
  description = "Optional grouping of policy definitions within the initiative."
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
