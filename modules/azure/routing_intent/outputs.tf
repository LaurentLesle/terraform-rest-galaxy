# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "id" {
  description = "The full ARM resource ID of the Routing Intent."
  value       = local.ri_path
}

output "name" {
  description = "The name of the Routing Intent (plan-time, echoes input)."
  value       = var.routing_intent_name
}

# ── Known after apply ─────────────────────────────────────────────────────────

output "provisioning_state" {
  description = "The provisioning state of the Routing Intent."
  value       = try(rest_resource.routing_intent.output.properties.provisioningState, null)
}
