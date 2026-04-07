# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "id" {
  description = "The full ARM resource ID of the GitHub.Network networkSettings resource."
  value       = local.ns_path
}

output "name" {
  description = "The name of the networkSettings resource."
  value       = var.network_settings_name
}

output "location" {
  description = "The location of the networkSettings resource."
  value       = var.location
}

output "subnet_id" {
  description = "The subnet ID associated with this network settings resource."
  value       = var.subnet_id
}

output "business_id" {
  description = "The GitHub business (organization/enterprise) ID."
  value       = var.business_id
}

# ── Known after apply (Azure-assigned) ───────────────────────────────────────

output "provisioning_state" {
  description = "The provisioning state."
  value       = try(rest_resource.github_network_settings.output.properties.provisioningState, null)
}
