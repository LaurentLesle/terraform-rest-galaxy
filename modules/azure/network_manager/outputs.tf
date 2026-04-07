# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "id" {
  description = "The full ARM resource ID of the network manager."
  value       = local.nm_path
}

output "name" {
  description = "The name of the network manager."
  value       = var.network_manager_name
}

output "resource_group_name" {
  description = "The resource group name (echoes input)."
  value       = var.resource_group_name
}

output "location" {
  description = "The location of the network manager."
  value       = var.location
}

# ── Known after apply ─────────────────────────────────────────────────────────

output "provisioning_state" {
  description = "The provisioning state."
  value       = try(rest_resource.network_manager.output.properties.provisioningState, null)
}
