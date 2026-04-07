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

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "cluster_name" {
  type        = string
  description = "The name of the parent Redis Enterprise cluster."
}

variable "database_name" {
  type        = string
  default     = "default"
  description = "The name of the database. Defaults to 'default'."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "client_protocol" {
  type        = string
  default     = "Encrypted"
  description = "Specifies whether redis clients connect using TLS-encrypted or plaintext. One of: 'Encrypted', 'Plaintext'."
}

variable "port" {
  type        = number
  default     = 10000
  description = "TCP port of the database endpoint. Specified at create time."
}

variable "clustering_policy" {
  type        = string
  default     = "OSSCluster"
  description = "Clustering policy. One of: 'EnterpriseCluster', 'OSSCluster', 'NoCluster'."
}

variable "eviction_policy" {
  type        = string
  default     = "VolatileLRU"
  description = "Redis eviction policy. One of: 'AllKeysLFU', 'AllKeysLRU', 'AllKeysRandom', 'VolatileLRU', 'VolatileLFU', 'VolatileTTL', 'VolatileRandom', 'NoEviction'."
}

variable "access_keys_authentication" {
  type        = string
  default     = null
  description = "Allow or deny access with current access keys. One of: 'Enabled', 'Disabled'."
}

variable "modules" {
  type = list(object({
    name = string
    args = optional(string)
  }))
  default     = null
  description = "Optional set of Redis modules to enable (can only be set at creation time)."
}

variable "persistence" {
  type = object({
    aof_enabled   = optional(bool)
    aof_frequency = optional(string)
    rdb_enabled   = optional(bool)
    rdb_frequency = optional(string)
  })
  default     = null
  description = "Persistence settings for the database."
}
