# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows."
}

# ── Scope ────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID."
}

# ── Parent scope ──────────────────────────────────────────────────────────────

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group containing the Email Communication Service."
}

variable "email_service_name" {
  type        = string
  description = "The name of the parent Email Communication Service."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "domain_name" {
  type        = string
  description = "The name of the domain. Use 'AzureManagedDomain' for Azure-managed domains or a custom domain name."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The geo-location where the resource lives. Typically 'global' for Email Communication Service domains."
}

variable "domain_management" {
  type        = string
  description = "How the domain is managed. Options: AzureManaged, CustomerManaged, CustomerManagedInExchangeOnline."

  validation {
    condition     = contains(["AzureManaged", "CustomerManaged", "CustomerManagedInExchangeOnline"], var.domain_management)
    error_message = "domain_management must be one of: AzureManaged, CustomerManaged, CustomerManagedInExchangeOnline."
  }
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "user_engagement_tracking" {
  type        = string
  default     = null
  description = "Whether user engagement tracking is enabled or disabled. Options: Enabled, Disabled."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags to assign to the Email Communication Service domain."
}
