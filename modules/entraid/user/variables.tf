# ── Required ──────────────────────────────────────────────────────────────────

variable "display_name" {
  type        = string
  description = "The name displayed in the address book for the user. Maximum length is 256 characters."
}

variable "mail_nickname" {
  type        = string
  description = "The mail alias for the user. Maximum length is 64 characters."
}

variable "user_principal_name" {
  type        = string
  description = "The user principal name (UPN). Format: alias@domain. The domain must be a verified domain of the tenant."
}

variable "account_enabled" {
  type        = bool
  description = "true if the account is enabled; otherwise, false."
}

variable "password_profile" {
  type = object({
    password                                    = string
    force_change_password_next_sign_in          = optional(bool, true)
    force_change_password_next_sign_in_with_mfa = optional(bool, false)
  })
  description = "The password profile for the user. The password must satisfy the tenant's password policy."
  sensitive   = true
}

# ── Optional ─────────────────────────────────────────────────────────────────

variable "given_name" {
  type        = string
  default     = null
  description = "The given name (first name) of the user. Maximum length is 64 characters."
}

variable "surname" {
  type        = string
  default     = null
  description = "The user's surname (family name or last name). Maximum length is 64 characters."
}

variable "job_title" {
  type        = string
  default     = null
  description = "The user's job title. Maximum length is 128 characters."
}

variable "department" {
  type        = string
  default     = null
  description = "The name for the department in which the user works. Maximum length is 64 characters."
}

variable "office_location" {
  type        = string
  default     = null
  description = "The office location in the user's place of business."
}

variable "city" {
  type        = string
  default     = null
  description = "The city in which the user is located. Maximum length is 128 characters."
}

variable "country" {
  type        = string
  default     = null
  description = "The country/region in which the user is located. Maximum length is 128 characters."
}

variable "state" {
  type        = string
  default     = null
  description = "The state or province in the user's address. Maximum length is 128 characters."
}

variable "postal_code" {
  type        = string
  default     = null
  description = "The postal code for the user's postal address."
}

variable "street_address" {
  type        = string
  default     = null
  description = "The street address of the user's place of business. Maximum length is 1024 characters."
}

variable "company_name" {
  type        = string
  default     = null
  description = "The company name associated with the user. Maximum length is 64 characters."
}

variable "mobile_phone" {
  type        = string
  default     = null
  description = "The primary cellular telephone number for the user."
}

variable "preferred_language" {
  type        = string
  default     = null
  description = "The preferred language for the user (ISO 639-1 code, e.g. en-US)."
}

variable "usage_location" {
  type        = string
  default     = null
  description = "A two-letter country code (ISO 3166). Required for users assigned licenses."
}

variable "user_type" {
  type        = string
  default     = null
  description = "Classify user types: Member or Guest."
}

variable "employee_id" {
  type        = string
  default     = null
  description = "The employee identifier assigned by the organization. Maximum length is 16 characters."
}

variable "employee_type" {
  type        = string
  default     = null
  description = "Captures enterprise worker type (e.g. Employee, Contractor, Consultant, Vendor)."
}

variable "other_mails" {
  type        = list(string)
  default     = null
  description = "Additional email addresses for the user."
}
