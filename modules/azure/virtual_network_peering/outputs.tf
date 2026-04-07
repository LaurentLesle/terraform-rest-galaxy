output "id" {
  description = "The full ARM resource ID of the VNet peering."
  value       = local.peering_path
}

output "name" {
  description = "The name of the VNet peering (plan-time, echoes input)."
  value       = var.peering_name
}

output "provisioning_state" {
  description = "The provisioning state."
  value       = try(rest_resource.virtual_network_peering.output.properties.provisioningState, null)
}

output "peering_state" {
  description = "The peering state (e.g. Connected, Initiated, Disconnected)."
  value       = try(rest_resource.virtual_network_peering.output.properties.peeringState, null)
}
