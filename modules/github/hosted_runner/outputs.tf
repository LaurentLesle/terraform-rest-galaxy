# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "name" {
  description = "The name of the hosted runner."
  value       = var.name
}

output "organization" {
  description = "The GitHub organization."
  value       = var.organization
}

output "size" {
  description = "The machine size."
  value       = var.size
}

output "runner_group_id" {
  description = "The runner group ID (input)."
  value       = var.runner_group_id
}

# ── Known after apply (server-assigned) ───────────────────────────────────────

output "id" {
  description = "The numeric ID of the hosted runner, assigned by GitHub."
  value       = try(rest_resource.hosted_runner.output.id, null)
}

output "status" {
  description = "The status of the hosted runner (Ready, Provisioning, etc.)."
  value       = try(rest_resource.hosted_runner.output.status, null)
}

output "platform" {
  description = "The operating system platform (e.g. linux-x64)."
  value       = try(rest_resource.hosted_runner.output.platform, null)
}
