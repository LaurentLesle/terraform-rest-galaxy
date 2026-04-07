# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "id" {
  description = "The full ARM resource ID of the IPAM pool."
  value       = local.pool_path
}

output "name" {
  description = "The name of the IPAM pool."
  value       = var.pool_name
}

output "resource_group_name" {
  description = "The resource group name (echoes input)."
  value       = var.resource_group_name
}

output "network_manager_name" {
  description = "The parent network manager name (echoes input)."
  value       = var.network_manager_name
}

output "location" {
  description = "The location of the IPAM pool."
  value       = var.location
}

# ── Known after apply ─────────────────────────────────────────────────────────

output "provisioning_state" {
  description = "The provisioning state."
  value       = try(rest_resource.ipam_pool.output.properties.provisioningState, null)
}
