# ── Scope ────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID."
}

# ── Parent scope ──────────────────────────────────────────────────────────────

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group containing the key vault."
}

variable "vault_name" {
  type        = string
  description = "The name of the key vault in which to create the key."
}

# ── Identity ──────────────────────────────────────────────────────────────────

variable "key_name" {
  type        = string
  description = "The name of the key to create."
}

# ── Required body properties ──────────────────────────────────────────────────

variable "key_type" {
  type        = string
  description = "The type of the key. Options: EC, EC-HSM, RSA, RSA-HSM."
}

# ── Optional body properties ──────────────────────────────────────────────────

variable "key_size" {
  type        = number
  default     = null
  description = "The key size in bits. For RSA: 2048, 3072, or 4096."
}

variable "curve_name" {
  type        = string
  default     = null
  description = "The elliptic curve name for EC keys. Options: P-256, P-256K, P-384, P-521."
}

variable "key_ops" {
  type        = list(string)
  default     = null
  description = "List of permitted JSON web key operations. Options: encrypt, decrypt, sign, verify, wrapKey, unwrapKey."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "Tags to assign to the key."
}
