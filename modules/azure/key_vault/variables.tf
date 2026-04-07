# ── Scope ────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID in which the key vault is created."
}

# ── Parent scope ──────────────────────────────────────────────────────────────

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the key vault."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "vault_name" {
  type        = string
  default     = null
  description = "The name of the key vault. Globally unique, 3–24 alphanumeric and hyphens."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "location" {
  type        = string
  description = "The Azure region in which the key vault is created."
}

variable "tenant_id" {
  type        = string
  description = "The Azure Active Directory tenant ID for authenticating requests to the key vault."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "sku_name" {
  type        = string
  default     = "standard"
  description = "The SKU name of the key vault. Options: standard, premium."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags to assign to the key vault."
}

variable "enable_rbac_authorization" {
  type        = bool
  default     = true
  description = "Use RBAC for data plane authorization instead of access policies. Default is true."
}

variable "enable_purge_protection" {
  type        = bool
  default     = null
  description = "Enable purge protection. Once enabled, cannot be disabled. Requires soft delete."
}

variable "enable_soft_delete" {
  type        = bool
  default     = true
  description = "Enable soft delete. Default is true; cannot be reverted to false once set."
}

variable "soft_delete_retention_in_days" {
  type        = number
  default     = 90
  description = "Soft delete retention in days (7–90). Default is 90."
}

variable "enabled_for_deployment" {
  type        = bool
  default     = null
  description = "Allow Azure VMs to retrieve certificates stored as secrets."
}

variable "enabled_for_disk_encryption" {
  type        = bool
  default     = null
  description = "Allow Azure Disk Encryption to retrieve secrets and unwrap keys."
}

variable "enabled_for_template_deployment" {
  type        = bool
  default     = null
  description = "Allow Azure Resource Manager to retrieve secrets."
}

variable "public_network_access" {
  type        = string
  default     = null
  description = "Control public network access. Options: enabled, disabled."
}

variable "create_mode" {
  type        = string
  default     = null
  description = "The vault's create mode. Set to 'recover' to recover a soft-deleted vault with the same name. Options: recover, default. When null, omitted from the request (normal create)."

  validation {
    condition     = var.create_mode == null || contains(["recover", "default"], var.create_mode)
    error_message = "create_mode must be null, 'recover', or 'default'."
  }
}

variable "network_acls" {
  type = object({
    default_action = string
    bypass         = optional(string, "AzureServices")
    ip_rules       = optional(list(string), [])
    virtual_network_rules = optional(list(object({
      id = string
    })), [])
  })
  default     = null
  description = "Network ACL rules for the key vault."
}

# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows."
}
