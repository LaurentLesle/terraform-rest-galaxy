output "id" {
  value       = local.nic_path
  description = "The resource ID of the network interface (plan-time)."
}

output "name" {
  value       = var.network_interface_name
  description = "The name of the network interface."
}

output "location" {
  value       = var.location
  description = "The Azure region."
}

output "provisioning_state" {
  value       = try(rest_resource.network_interface.output.properties.provisioningState, null)
  description = "The provisioning state (known after apply)."
}
