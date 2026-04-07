# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "id" {
  description = "The full ARM resource ID of the Azure Firewall."
  value       = local.fw_path
}

output "name" {
  description = "The name of the Azure Firewall (plan-time, echoes input)."
  value       = var.firewall_name
}

output "location" {
  description = "The location of the Azure Firewall (plan-time, echoes input)."
  value       = var.location
}

# ── Known after apply ─────────────────────────────────────────────────────────

output "provisioning_state" {
  description = "The provisioning state of the Azure Firewall."
  value       = try(rest_resource.azure_firewall.output.properties.provisioningState, null)
}

output "private_ip_address" {
  description = "The private IP address of the hub firewall."
  value       = try(rest_resource.azure_firewall.output.properties.hubIPAddresses.privateIPAddress, null)
}

output "public_ip_addresses" {
  description = "The public IP addresses of the hub firewall."
  value       = try(rest_resource.azure_firewall.output.properties.hubIPAddresses.publicIPs.addresses, null)
}
