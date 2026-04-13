# ── Provider behaviour ─────────────────────────────────────────────────────

variable "check_existance" {
  type        = bool
  default     = false
  description = "When true, the provider GETs the variable before creating it and adopts it into state if it already exists. Use this to reconcile drift or when a previous apply left the resource orphaned."
}

# ── Scope ────────────────────────────────────────────────────────────────────

variable "owner" {
  type        = string
  description = "The account owner of the repository (user or organization)."
}

variable "repo" {
  type        = string
  description = "The repository name (without .git extension)."
}

variable "environment_name" {
  type        = string
  description = "The name of the deployment environment (e.g. staging, production)."
}

# ── Required ──────────────────────────────────────────────────────────────────

variable "name" {
  type        = string
  description = "The name of the environment-scoped Actions variable (e.g. API_URL)."
}

variable "value" {
  type        = string
  description = "The value of the environment-scoped Actions variable."
}
