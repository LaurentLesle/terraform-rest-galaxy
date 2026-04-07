# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "name" {
  description = "The name of the runner group."
  value       = var.name
}

output "organization" {
  description = "The GitHub organization."
  value       = var.organization
}

output "visibility" {
  description = "The visibility of the runner group."
  value       = var.visibility
}

output "network_configuration_id" {
  description = "The ARM resource ID of the network configuration."
  value       = var.network_configuration_id
}

# ── Known after apply (server-assigned) ───────────────────────────────────────

output "id" {
  description = "The numeric ID of the runner group, assigned by GitHub."
  value       = try(rest_resource.runner_group.output.id, null)
}
