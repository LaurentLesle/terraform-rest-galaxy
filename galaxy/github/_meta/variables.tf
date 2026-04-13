# ── GitHub Variables ──────────────────────────────────────────────────────────

variable "github_token" {
  type        = string
  sensitive   = true
  default     = null
  description = "GitHub personal access token or GitHub App token. Required when managing GitHub resources (repositories, teams, branch protection, etc.)."
}

variable "github_check_existance" {
  type        = bool
  default     = false
  description = "Check whether GitHub resources already exist before creating them. When true, the provider performs a GET before PUT/POST and imports the resource into state if it exists. Set to true for brownfield import workflows (tf-import). Defaults to false for greenfield deployments."
}
