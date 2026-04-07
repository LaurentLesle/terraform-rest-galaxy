output "id" {
  value       = local.vngw_path
  description = "The resource ID of the virtual network gateway (plan-time)."
}

output "name" {
  value       = var.gateway_name
  description = "The name of the virtual network gateway."
}

output "location" {
  value       = var.location
  description = "The Azure region."
}

output "provisioning_state" {
  value       = try(rest_resource.virtual_network_gateway.output.properties.provisioningState, null)
  description = "The provisioning state (known after apply)."
}
