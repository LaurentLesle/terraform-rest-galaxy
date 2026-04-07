# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "name" {
  description = "The name of the Actions secret."
  value       = var.secret_name
}

output "owner" {
  description = "The repository owner."
  value       = var.owner
}

output "repo" {
  description = "The repository name."
  value       = var.repo
}
