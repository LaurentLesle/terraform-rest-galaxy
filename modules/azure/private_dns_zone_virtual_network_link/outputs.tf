output "id" {
  description = "The full ARM resource ID of the virtual network link (plan-time, built from inputs)."
  value       = local.link_path
}

output "api_version" {
  description = "The ARM API version used to manage this resource."
  value       = local.api_version
}

output "name" {
  description = "The name of the virtual network link (plan-time, echoes input)."
  value       = var.virtual_network_link_name
}

output "virtual_network_link_state" {
  description = "The status of the virtual network link to the Private DNS Zone (known after apply)."
  value       = try(rest_resource.private_dns_zone_virtual_network_link.output.properties.virtualNetworkLinkState, null)
}

output "provisioning_state" {
  description = "The provisioning state of the virtual network link (known after apply)."
  value       = try(rest_resource.private_dns_zone_virtual_network_link.output.properties.provisioningState, null)
}
