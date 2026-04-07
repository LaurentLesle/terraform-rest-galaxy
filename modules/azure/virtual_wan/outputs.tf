# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "id" {
  description = "The full ARM resource ID of the Virtual WAN."
  value       = local.vwan_path
}

output "name" {
  description = "The name of the Virtual WAN (plan-time, echoes input)."
  value       = var.virtual_wan_name
}

output "location" {
  description = "The location of the Virtual WAN (plan-time, echoes input)."
  value       = var.location
}

# ── Known after apply ─────────────────────────────────────────────────────────

output "provisioning_state" {
  description = "The provisioning state of the Virtual WAN."
  value       = try(rest_resource.virtual_wan.output.properties.provisioningState, null)
}
