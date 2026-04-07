# ── Scope ────────────────────────────────────────────────────────────────────

variable "organization" {
  type        = string
  description = "The GitHub organization name."
}

# ── Required ──────────────────────────────────────────────────────────────────

variable "name" {
  type        = string
  description = "Name of the runner group."
}

# ── Optional ──────────────────────────────────────────────────────────────────

variable "visibility" {
  type        = string
  default     = "all"
  description = "Visibility of the runner group. One of: selected, all, private."
}

variable "allows_public_repositories" {
  type        = bool
  default     = false
  description = "Whether the runner group can be used by public repositories."
}

variable "restricted_to_workflows" {
  type        = bool
  default     = false
  description = "If true, restrict the runner group to the workflows listed in selected_workflows."
}

variable "selected_workflows" {
  type        = list(string)
  default     = null
  description = "List of workflows the runner group is allowed to run (e.g. 'org/repo/.github/workflows/deploy.yaml@main')."
}

variable "network_configuration_id" {
  type        = string
  default     = null
  description = "The ARM resource ID of the GitHub.Network/networkSettings resource for VNet injection."
}
