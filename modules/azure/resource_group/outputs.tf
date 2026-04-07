output "id" {
  description = "The full ARM resource ID of the resource group (e.g. /subscriptions/.../resourcegroups/myRG)."
  value       = local.rg_path
}

output "api_version" {
  description = "The ARM API version used to manage this resource group."
  value       = "2025-04-01"
}

# Read-only properties surfaced from the ARM GET response.

output "name" {
  description = "The name of the resource group (plan-time, echoes input)."
  value       = var.resource_group_name
}

output "type" {
  description = "The resource type string returned by ARM (e.g. Microsoft.Resources/resourceGroups)."
  value       = try(rest_resource.resource_group.output.type, null)
}

output "provisioning_state" {
  description = "The provisioning state of the resource group (e.g. Succeeded)."
  value       = try(rest_resource.resource_group.output.properties.provisioningState, null)
}

output "location" {
  description = "The location of the resource group (plan-time, echoes input)."
  value       = var.location
}

output "tags" {
  description = "The tags attached to the resource group (plan-time, echoes input)."
  value       = var.tags
}

output "resource_group_name" {
  description = "The name of the resource group (echoes the input for cross-module references)."
  value       = var.resource_group_name
}
