# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "id" {
  description = "The full ARM resource ID of the Virtual Hub."
  value       = local.vhub_path
}

output "name" {
  description = "The name of the Virtual Hub (plan-time, echoes input)."
  value       = var.virtual_hub_name
}

output "location" {
  description = "The location of the Virtual Hub (plan-time, echoes input)."
  value       = var.location
}

output "address_prefix" {
  description = "The address prefix of the Virtual Hub (plan-time, echoes input)."
  value       = var.address_prefix
}

# ── Known after apply ─────────────────────────────────────────────────────────

output "provisioning_state" {
  description = "The provisioning state of the Virtual Hub."
  value       = try(rest_resource.virtual_hub.output.properties.provisioningState, null)
}

output "routing_state" {
  description = "The routing state of the Virtual Hub."
  value       = try(rest_resource.virtual_hub.output.properties.routingState, null)
}
