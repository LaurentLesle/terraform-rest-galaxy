# ── Required ──────────────────────────────────────────────────────────────────

variable "display_name" {
  type        = string
  description = "The display name for the group. Maximum length is 256 characters."
}

variable "mail_enabled" {
  type        = bool
  description = "Specifies whether the group is mail-enabled. Required."
}

variable "mail_nickname" {
  type        = string
  description = "The mail alias for the group, unique for Microsoft 365 groups in the organization. Maximum length is 64 characters."
}

variable "security_enabled" {
  type        = bool
  description = "Specifies whether the group is a security group. Required."
}

# ── Optional ─────────────────────────────────────────────────────────────────

variable "description" {
  type        = string
  default     = null
  description = "An optional description for the group."
}

variable "group_types" {
  type        = list(string)
  default     = null
  description = "Specifies the group type. Use [\"Unified\"] for Microsoft 365 groups. Omit or use [] for security groups."
}

variable "visibility" {
  type        = string
  default     = null
  description = "Specifies the group join policy and content visibility. Possible values: Private, Public, HiddenMembership."
}

variable "is_assignable_to_role" {
  type        = bool
  default     = null
  description = "Indicates whether this group can be assigned to an Azure AD role. Immutable after creation."
}

variable "membership_rule" {
  type        = string
  default     = null
  description = "The rule that determines members for this group if it is a dynamic group."
}

variable "membership_rule_processing_state" {
  type        = string
  default     = null
  description = "Indicates whether dynamic membership processing is On or Paused."
}
