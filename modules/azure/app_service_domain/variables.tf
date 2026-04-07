# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it."
}

# ── Scope ────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID."
}

# ── Parent scope ──────────────────────────────────────────────────────────────

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the domain."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "domain_name" {
  type        = string
  description = "The domain name to register (e.g. contoso.com)."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  default     = "global"
  description = "The geo-location. App Service Domains use 'global'."
}

variable "contact_admin" {
  type = object({
    first_name    = string
    last_name     = string
    email         = string
    phone         = string
    organization  = optional(string, null)
    job_title     = optional(string, null)
    fax           = optional(string, null)
    middle_name   = optional(string, null)
    address_line1 = optional(string, null)
    address_line2 = optional(string, null)
    city          = optional(string, null)
    state         = optional(string, null)
    country       = optional(string, null)
    postal_code   = optional(string, null)
  })
  description = "Administrative contact for domain registration."
}

variable "contact_billing" {
  type = object({
    first_name    = string
    last_name     = string
    email         = string
    phone         = string
    organization  = optional(string, null)
    job_title     = optional(string, null)
    fax           = optional(string, null)
    middle_name   = optional(string, null)
    address_line1 = optional(string, null)
    address_line2 = optional(string, null)
    city          = optional(string, null)
    state         = optional(string, null)
    country       = optional(string, null)
    postal_code   = optional(string, null)
  })
  description = "Billing contact for domain registration."
}

variable "contact_registrant" {
  type = object({
    first_name    = string
    last_name     = string
    email         = string
    phone         = string
    organization  = optional(string, null)
    job_title     = optional(string, null)
    fax           = optional(string, null)
    middle_name   = optional(string, null)
    address_line1 = optional(string, null)
    address_line2 = optional(string, null)
    city          = optional(string, null)
    state         = optional(string, null)
    country       = optional(string, null)
    postal_code   = optional(string, null)
  })
  description = "Registrant contact for domain registration (WHOIS owner)."
}

variable "contact_tech" {
  type = object({
    first_name    = string
    last_name     = string
    email         = string
    phone         = string
    organization  = optional(string, null)
    job_title     = optional(string, null)
    fax           = optional(string, null)
    middle_name   = optional(string, null)
    address_line1 = optional(string, null)
    address_line2 = optional(string, null)
    city          = optional(string, null)
    state         = optional(string, null)
    country       = optional(string, null)
    postal_code   = optional(string, null)
  })
  description = "Technical contact for domain registration."
}

variable "consent_agreed_by" {
  type        = string
  description = "IP address of the person who agreed to the legal agreements."
}

variable "consent_agreed_at" {
  type        = string
  description = "ISO 8601 timestamp when the legal agreements were accepted (e.g. 2026-04-07T00:00:00Z)."
}

variable "consent_agreement_keys" {
  type        = list(string)
  default     = []
  description = "List of legal agreement keys. Retrieve using TopLevelDomains_ListAgreements API. Empty list accepts all agreements."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "privacy" {
  type        = bool
  default     = true
  description = "Enable WHOIS privacy protection."
}

variable "auto_renew" {
  type        = bool
  default     = true
  description = "Automatically renew the domain."
}

variable "dns_type" {
  type        = string
  default     = "AzureDns"
  description = "DNS type: AzureDns or DefaultDomainRegistrarDns."
}

variable "dns_zone_id" {
  type        = string
  default     = null
  description = "Azure DNS zone resource ID. When dns_type is AzureDns, Azure auto-creates a zone if omitted."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags to assign to the domain."
}
