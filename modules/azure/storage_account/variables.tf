# ── Scope ────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID in which the storage account is created."
}

# ── Parent scope ──────────────────────────────────────────────────────────────

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the storage account."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "account_name" {
  type        = string
  default     = null
  description = "The name of the storage account. Globally unique, 3–24 lowercase alphanumeric characters."

  validation {
    condition     = var.account_name == null || can(regex("^[a-z0-9]{3,24}$", var.account_name))
    error_message = "account_name must be 3–24 lowercase alphanumeric characters."
  }
}

# ── Required body properties ──────────────────────────────────────────────────

variable "sku_name" {
  type        = string
  description = "The SKU name. Options: Standard_LRS, Standard_GRS, Standard_RAGRS, Standard_ZRS, Premium_LRS, Premium_ZRS, Standard_GZRS, Standard_RAGZRS."

  validation {
    condition     = contains(["Standard_LRS", "Standard_GRS", "Standard_RAGRS", "Standard_ZRS", "Premium_LRS", "Premium_ZRS", "Standard_GZRS", "Standard_RAGZRS"], var.sku_name)
    error_message = "sku_name must be one of: Standard_LRS, Standard_GRS, Standard_RAGRS, Standard_ZRS, Premium_LRS, Premium_ZRS, Standard_GZRS, Standard_RAGZRS."
  }
}

variable "kind" {
  type        = string
  description = "The type of storage account. Options: Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage."

  validation {
    condition     = contains(["Storage", "StorageV2", "BlobStorage", "FileStorage", "BlockBlobStorage"], var.kind)
    error_message = "kind must be one of: Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage."
  }
}

variable "location" {
  type        = string
  description = "The Azure region in which the storage account is created. Cannot be changed after creation."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags to assign to the storage account (maximum 15)."
}

variable "zones" {
  type        = list(string)
  default     = null
  description = "Pinned logical availability zones for the storage account."
}

variable "identity_type" {
  type        = string
  default     = null
  description = "The type of managed identity. Options: None, SystemAssigned, UserAssigned, SystemAssigned,UserAssigned."

  validation {
    condition     = var.identity_type == null || contains(["None", "SystemAssigned", "UserAssigned", "SystemAssigned,UserAssigned"], var.identity_type)
    error_message = "identity_type must be one of: None, SystemAssigned, UserAssigned, SystemAssigned,UserAssigned."
  }
}

variable "identity_user_assigned_identity_ids" {
  type        = list(string)
  default     = null
  description = "List of user-assigned managed identity ARM resource IDs to associate with this storage account."
}

variable "access_tier" {
  type        = string
  default     = null
  description = "Required for kind = BlobStorage. Billing access tier. Options: Hot, Cool, Cold, Premium."

  validation {
    condition     = var.access_tier == null || contains(["Hot", "Cool", "Cold", "Premium"], var.access_tier)
    error_message = "access_tier must be one of: Hot, Cool, Cold, Premium."
  }
}

variable "https_traffic_only_enabled" {
  type        = bool
  default     = true
  description = "Allow only HTTPS traffic to the storage service. Default is true."
}

variable "minimum_tls_version" {
  type        = string
  default     = "TLS1_2"
  description = "Minimum TLS version permitted on requests. Options: TLS1_0, TLS1_1, TLS1_2."

  validation {
    condition     = contains(["TLS1_0", "TLS1_1", "TLS1_2"], var.minimum_tls_version)
    error_message = "minimum_tls_version must be one of: TLS1_0, TLS1_1, TLS1_2."
  }
}

variable "allow_blob_public_access" {
  type        = bool
  default     = false
  description = "Allow or disallow public access to all blobs or containers. Default is false."
}

variable "allow_shared_key_access" {
  type        = bool
  default     = null
  description = "Whether the storage account permits Shared Key authorization. Null is equivalent to true."
}

variable "is_hns_enabled" {
  type        = bool
  default     = null
  description = "Enable Hierarchical Namespace (Azure Data Lake Storage Gen2). Immutable after creation."
}

variable "public_network_access" {
  type        = string
  default     = null
  description = "Control public network access. Options: Enabled, Disabled, SecuredByPerimeter."

  validation {
    condition     = var.public_network_access == null || contains(["Enabled", "Disabled", "SecuredByPerimeter"], var.public_network_access)
    error_message = "public_network_access must be one of: Enabled, Disabled, SecuredByPerimeter."
  }
}

variable "default_to_oauth_authentication" {
  type        = bool
  default     = null
  description = "Set the default authentication to OAuth/Entra ID. Default interpretation is false."
}

variable "allow_cross_tenant_replication" {
  type        = bool
  default     = null
  description = "Allow or disallow cross-AAD-tenant object replication. Default is false for new accounts."
}

variable "network_acls" {
  type = object({
    default_action             = string
    bypass                     = optional(list(string), ["AzureServices"])
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default     = null
  description = "Network ACL rules. When set, default_action must be 'Allow' or 'Deny'."
}

# ── Encryption (CMK) ─────────────────────────────────────────────────────────

variable "encryption_key_source" {
  type        = string
  default     = null
  description = "The encryption key source. Options: Microsoft.Storage, Microsoft.Keyvault. Set to Microsoft.Keyvault for CMK."

  validation {
    condition     = var.encryption_key_source == null || contains(["Microsoft.Storage", "Microsoft.Keyvault"], var.encryption_key_source)
    error_message = "encryption_key_source must be one of: Microsoft.Storage, Microsoft.Keyvault."
  }
}

variable "encryption_key_vault_uri" {
  type        = string
  default     = null
  description = "The URI of the key vault hosting the customer-managed key."
}

variable "encryption_key_name" {
  type        = string
  default     = null
  description = "The name of the key vault key used for CMK encryption."
}

variable "encryption_key_version" {
  type        = string
  default     = null
  description = "The version of the key vault key. Omit for automatic key rotation."
}

variable "encryption_identity" {
  type        = string
  default     = null
  description = "The ARM resource ID of the user-assigned identity used to access the key vault for CMK encryption."
}

variable "encryption_require_infrastructure_encryption" {
  type        = bool
  default     = null
  description = "Enable a secondary layer of encryption with platform-managed keys."
}

# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "Check whether the resource already exists before creating it. When true, the provider performs a GET before PUT and imports the resource into state if it exists. Set to true for brownfield import workflows."
}
