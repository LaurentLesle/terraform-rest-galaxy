# ── Scope ────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID in which to register the resource provider."
}

# ── Required ──────────────────────────────────────────────────────────────────

variable "resource_provider_namespace" {
  type        = string
  description = "The namespace of the resource provider to register (e.g. Microsoft.Compute, Microsoft.KeyVault)."
}

variable "header" {
  type        = map(string)
  default     = {}
  sensitive   = true
  description = "Optional HTTP headers to override for this resource (e.g. cross-tenant Authorization)."
}

variable "skip_deregister" {
  type        = bool
  default     = true
  description = "Skip unregistering the provider on destroy. Defaults to true because Azure often rejects unregistration when resources still exist."
}
