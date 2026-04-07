# ── Scope ────────────────────────────────────────────────────────────────────

variable "subscription_id" {
  type        = string
  description = "The Azure subscription ID."
}

variable "resource_group_name" {
  type        = string
  description = "The resource group name of the target registry."
}

variable "registry_name" {
  type        = string
  description = "The name of the target container registry."
}

# ── Source ────────────────────────────────────────────────────────────────────

variable "source_registry_uri" {
  type        = string
  description = "The source registry URI (e.g. 'mcr.microsoft.com')."
}

variable "source_image" {
  type        = string
  description = "Source image reference (repo:tag or repo@digest)."
}

# ── Target ───────────────────────────────────────────────────────────────────

variable "target_tags" {
  type        = list(string)
  default     = null
  description = "List of target tags (repo:tag). Defaults to source tag."
}

variable "mode" {
  type        = string
  default     = "Force"
  description = "Import mode: Force or NoForce."
}
