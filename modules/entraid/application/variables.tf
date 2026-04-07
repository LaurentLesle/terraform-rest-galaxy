# ── Required ──────────────────────────────────────────────────────────────────

variable "display_name" {
  type        = string
  description = "The display name for the application. Supports $filter (eq, ne, not, ge, le, in, startsWith)."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "sign_in_audience" {
  type        = string
  default     = "AzureADMyOrg"
  description = <<-EOT
    Specifies the Microsoft accounts supported. Possible values:
    - AzureADMyOrg (default, most restrictive — single tenant)
    - AzureADMultipleOrgs (any Azure AD tenant)
    - AzureADandPersonalMicrosoftAccount (any Azure AD + personal Microsoft)
    - PersonalMicrosoftAccount (personal only)
  EOT

  validation {
    condition     = contains(["AzureADMyOrg", "AzureADMultipleOrgs", "AzureADandPersonalMicrosoftAccount", "PersonalMicrosoftAccount"], var.sign_in_audience)
    error_message = "sign_in_audience must be one of: AzureADMyOrg, AzureADMultipleOrgs, AzureADandPersonalMicrosoftAccount, PersonalMicrosoftAccount."
  }
}

variable "description" {
  type        = string
  default     = null
  description = "Free text field to provide a description of the application object. Maximum 1024 characters."
}

variable "notes" {
  type        = string
  default     = null
  description = "Notes relevant for the management of the application."
}

variable "identifier_uris" {
  type        = list(string)
  default     = null
  description = "App ID URIs used when the application is used as a resource app. Must be globally unique."
}

variable "tags" {
  type        = list(string)
  default     = null
  description = "Custom strings that can be used to categorize and identify the application."
}

variable "group_membership_claims" {
  type        = string
  default     = null
  description = "Configures the groups claim. One of: None, SecurityGroup, All."
}

variable "is_fallback_public_client" {
  type        = bool
  default     = false
  description = "Specifies the fallback application type as public client. Default is false (confidential client)."
}

variable "is_device_only_auth_supported" {
  type        = bool
  default     = null
  description = "Specifies whether this application supports device authentication without a user."
}

# ── Web application settings ──────────────────────────────────────────────────

variable "web" {
  type = object({
    redirect_uris                = optional(list(string), null)
    home_page_url                = optional(string, null)
    logout_url                   = optional(string, null)
    implicit_grant_access_tokens = optional(bool, false)
    implicit_grant_id_tokens     = optional(bool, false)
  })
  default     = null
  description = "Specifies settings for a web application including redirect URIs and implicit grant settings."
}

# ── SPA settings ──────────────────────────────────────────────────────────────

variable "spa" {
  type = object({
    redirect_uris = list(string)
  })
  default     = null
  description = "Specifies settings for a single-page application, including redirect URIs."
}

# ── Public client settings ────────────────────────────────────────────────────

variable "public_client" {
  type = object({
    redirect_uris = list(string)
  })
  default     = null
  description = "Specifies settings for installed clients such as desktop or mobile devices."
}

# ── API settings ──────────────────────────────────────────────────────────────

variable "api" {
  type = object({
    requested_access_token_version = optional(number, 2)
    oauth2_permission_scopes = optional(list(object({
      admin_consent_description  = string
      admin_consent_display_name = string
      id                         = string
      is_enabled                 = optional(bool, true)
      type                       = optional(string, "User")
      user_consent_description   = optional(string, null)
      user_consent_display_name  = optional(string, null)
      value                      = string
    })), null)
  })
  default     = null
  description = "Specifies settings for an application that implements a web API."
}

# ── Required resource access (API permissions) ────────────────────────────────

variable "required_resource_access" {
  type = list(object({
    resource_app_id = string
    resource_access = list(object({
      id   = string
      type = string
    }))
  }))
  default     = null
  description = "Specifies the resources the application needs to access, including delegated permissions and application roles."
}

# ── App roles ─────────────────────────────────────────────────────────────────

variable "app_roles" {
  type = list(object({
    allowed_member_types = list(string)
    description          = string
    display_name         = string
    id                   = string
    is_enabled           = optional(bool, true)
    value                = optional(string, null)
  }))
  default     = null
  description = "The collection of roles defined for the application."
}

# ── Optional claims ───────────────────────────────────────────────────────────

variable "optional_claims" {
  type = object({
    access_token = optional(list(object({
      name                  = string
      additional_properties = optional(list(string), null)
      essential             = optional(bool, false)
      source                = optional(string, null)
    })), null)
    id_token = optional(list(object({
      name                  = string
      additional_properties = optional(list(string), null)
      essential             = optional(bool, false)
      source                = optional(string, null)
    })), null)
    saml2_token = optional(list(object({
      name                  = string
      additional_properties = optional(list(string), null)
      essential             = optional(bool, false)
      source                = optional(string, null)
    })), null)
  })
  default     = null
  description = "Optional claims configuration for access tokens, ID tokens, and SAML tokens."
}
