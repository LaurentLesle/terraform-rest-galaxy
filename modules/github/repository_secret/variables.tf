# ── Scope ────────────────────────────────────────────────────────────────────

variable "owner" {
  type        = string
  description = "The account owner of the repository (user or organization)."
}

variable "repo" {
  type        = string
  description = "The repository name (without .git extension)."
}

# ── Required ──────────────────────────────────────────────────────────────────

variable "secret_name" {
  type        = string
  description = "The name of the Actions secret (e.g. AZURE_CLIENT_ID)."
}

variable "plaintext_value" {
  type        = string
  sensitive   = true
  description = "The secret value in plain text. It will be encrypted with the repository's public key before upload."
}
