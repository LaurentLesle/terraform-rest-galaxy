# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "id" {
  description = "The full ARM resource ID of the VPN gateway."
  value       = local.vpngw_path
}

output "name" {
  description = "The name of the VPN gateway (plan-time, echoes input)."
  value       = var.gateway_name
}

output "location" {
  description = "The location of the VPN gateway (plan-time, echoes input)."
  value       = var.location
}

# ── Known after apply ─────────────────────────────────────────────────────────

output "provisioning_state" {
  description = "The provisioning state of the VPN gateway."
  value       = try(rest_resource.vpn_gateway.output.properties.provisioningState, null)
}
