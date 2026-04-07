# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "id" {
  description = "The full ARM resource ID of the static CIDR allocation."
  value       = local.static_cidr_path
}

output "name" {
  description = "The name of the static CIDR allocation."
  value       = var.static_cidr_name
}

output "pool_name" {
  description = "The parent IPAM pool name (echoes input)."
  value       = var.pool_name
}

output "network_manager_name" {
  description = "The parent network manager name (echoes input)."
  value       = var.network_manager_name
}

output "address_prefixes" {
  description = "The reserved IP address prefixes (echoes input)."
  value       = var.address_prefixes
}

output "address_prefix" {
  description = "The first reserved IP address prefix (convenience for single-prefix reservations)."
  value       = try(var.address_prefixes[0], null)
}

# ── Known after apply ─────────────────────────────────────────────────────────

output "provisioning_state" {
  description = "The provisioning state."
  value       = try(rest_resource.ipam_static_cidr.output.properties.provisioningState, null)
}

output "total_number_of_ip_addresses" {
  description = "Total number of IP addresses allocated."
  value       = try(rest_resource.ipam_static_cidr.output.properties.totalNumberOfIPAddresses, null)
}
