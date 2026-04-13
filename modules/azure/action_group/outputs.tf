output "id" {
  description = "The full ARM resource ID of the action group (plan-time known)."
  value       = local.ag_path
}

output "name" {
  description = "The name of the action group (plan-time, echoes input)."
  value       = var.action_group_name
}

output "location" {
  description = "The location of the action group (plan-time, echoes input)."
  value       = var.location
}

output "resource_group_name" {
  description = "The resource group name (plan-time, echoes input)."
  value       = var.resource_group_name
}

output "api_version" {
  description = "The ARM API version used to manage this action group."
  value       = local.api_version
}

output "provisioning_state" {
  description = "The provisioning state of the action group."
  value       = try(rest_resource.action_group.output.properties.provisioningState, null)
}

output "enabled" {
  description = "Indicates whether the action group is enabled (plan-time, echoes input)."
  value       = var.enabled
}

output "short_name" {
  description = "The short name of the action group (plan-time, echoes input)."
  value       = var.short_name
}
