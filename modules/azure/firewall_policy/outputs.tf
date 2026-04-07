# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "id" {
  description = "The full ARM resource ID of the Firewall Policy."
  value       = local.fp_path
}

output "name" {
  description = "The name of the Firewall Policy (plan-time, echoes input)."
  value       = var.firewall_policy_name
}

output "location" {
  description = "The location of the Firewall Policy (plan-time, echoes input)."
  value       = var.location
}

# ── Known after apply ─────────────────────────────────────────────────────────

output "provisioning_state" {
  description = "The provisioning state of the Firewall Policy."
  value       = try(rest_resource.firewall_policy.output.properties.provisioningState, null)
}
