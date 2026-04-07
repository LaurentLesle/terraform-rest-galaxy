# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "id" {
  description = "The full ARM resource ID of the ExpressRoute port."
  value       = local.erp_path
}

output "name" {
  description = "The name of the ExpressRoute port (plan-time, echoes input)."
  value       = var.port_name
}

output "location" {
  description = "The location of the ExpressRoute port (plan-time, echoes input)."
  value       = var.location
}

# ── Known after apply ─────────────────────────────────────────────────────────

output "provisioning_state" {
  description = "The provisioning state of the ExpressRoute port."
  value       = try(rest_resource.express_route_port.output.properties.provisioningState, null)
}

output "ether_type" {
  description = "The Ether type of the physical port."
  value       = try(rest_resource.express_route_port.output.properties.etherType, null)
}

output "mtu" {
  description = "Maximum transmission unit of the physical port pair(s)."
  value       = try(rest_resource.express_route_port.output.properties.mtu, null)
}
