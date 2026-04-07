output "id" {
  description = "The full ARM resource ID of the Private DNS zone."
  value       = local.zone_path
}

output "api_version" {
  description = "The ARM API version used to manage this Private DNS zone."
  value       = local.api_version
}

output "name" {
  description = "The name of the Private DNS zone (plan-time, echoes input)."
  value       = var.zone_name
}

output "resource_group_name" {
  description = "The resource group name (plan-time, echoes input)."
  value       = var.resource_group_name
}

output "provisioning_state" {
  description = "The provisioning state of the Private DNS zone."
  value       = try(rest_resource.private_dns_zone.output.properties.provisioningState, null)
}

output "type" {
  description = "The ARM resource type string."
  value       = try(rest_resource.private_dns_zone.output.type, null)
}

output "virtual_network_link_ids" {
  description = "Map of virtual network link IDs, keyed by link name."
  value       = { for k, v in rest_resource.virtual_network_link : k => "${local.zone_path}/virtualNetworkLinks/${k}" }
}
