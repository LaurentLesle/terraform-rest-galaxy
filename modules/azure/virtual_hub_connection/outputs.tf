# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "id" {
  description = "The full ARM resource ID of the hub virtual network connection."
  value       = local.hvnc_path
}

output "name" {
  description = "The name of the hub virtual network connection (plan-time, echoes input)."
  value       = var.connection_name
}

# ── Known after apply ─────────────────────────────────────────────────────────

output "provisioning_state" {
  description = "The provisioning state of the hub virtual network connection."
  value       = try(rest_resource.virtual_hub_connection.output.properties.provisioningState, null)
}
