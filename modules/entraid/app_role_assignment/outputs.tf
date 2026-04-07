output "id" {
  description = "The unique identifier of the app role assignment."
  value       = try(rest_resource.app_role_assignment.output.id, null)
}

output "principal_display_name" {
  description = "The display name of the assigned principal."
  value       = try(rest_resource.app_role_assignment.output.principalDisplayName, null)
}

output "principal_type" {
  description = "The type of the assigned principal (User, Group, ServicePrincipal)."
  value       = try(rest_resource.app_role_assignment.output.principalType, null)
}

output "resource_display_name" {
  description = "The display name of the resource (Enterprise Application)."
  value       = try(rest_resource.app_role_assignment.output.resourceDisplayName, null)
}

output "resource_id" {
  description = "The service principal object ID of the Enterprise Application."
  value       = local.resource_id
}
