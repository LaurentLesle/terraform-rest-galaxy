output "id" {
  value       = local.conn_path
  description = "The resource ID of the virtual network gateway connection (plan-time)."
}

output "name" {
  value       = var.connection_name
  description = "The name of the virtual network gateway connection."
}

output "location" {
  value       = var.location
  description = "The Azure region."
}

output "provisioning_state" {
  value       = try(rest_resource.virtual_network_gateway_connection.output.properties.provisioningState, null)
  description = "The provisioning state (known after apply)."
}
