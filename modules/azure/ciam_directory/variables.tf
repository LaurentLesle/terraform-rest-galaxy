# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows."
}

# ── Scope ────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID linked to the CIAM directory."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which the CIAM directory resource is created."
}

variable "resource_name" {
  type        = string
  description = "The name of the Azure AD for customers (CIAM) directory resource."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The data-residency location for the tenant. One of: 'United States', 'Europe', 'Asia Pacific', 'Australia'. See https://aka.ms/ciam-data-location."
}

variable "display_name" {
  type        = string
  description = "The display name of the Azure AD for customers tenant."
}

variable "country_code" {
  type        = string
  description = "Country code of the tenant (e.g. 'US'). See https://aka.ms/ciam-data-location for valid codes."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "sku_name" {
  type        = string
  default     = "Standard"
  description = "The SKU name for the tenant. One of: 'Standard', 'PremiumP1', 'PremiumP2'."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Resource tags for the CIAM directory."
}
