output "id" {
  description = "The full ARM resource ID of the virtual network."
  value       = local.vnet_path
}

output "name" {
  description = "The name of the virtual network."
  value       = var.virtual_network_name
}

output "location" {
  description = "The location of the virtual network."
  value       = var.location
}

output "subnet_ids" {
  description = "Map of subnet name to full ARM subnet resource ID."
  value       = var.subnets != null ? { for s in var.subnets : s.name => "${local.vnet_path}/subnets/${s.name}" } : {}
}

output "provisioning_state" {
  description = "The provisioning state."
  value       = try(rest_resource.virtual_network.output.properties.provisioningState, null)
}
