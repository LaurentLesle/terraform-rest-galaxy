output "id" {
  description = "The full ARM resource ID of the role assignment."
  value       = local.ra_path
}

output "api_version" {
  description = "The ARM API version used to manage this role assignment."
  value       = "2022-04-01"
}

output "name" {
  description = "The GUID name of the role assignment."
  value       = try(rest_resource.role_assignment.output.name, null)
}

output "type" {
  description = "The resource type string returned by ARM."
  value       = try(rest_resource.role_assignment.output.type, null)
}

output "principal_id" {
  description = "The principal ID of the role assignment."
  value       = try(rest_resource.role_assignment.output.properties.principalId, null)
}

output "role_definition_id" {
  description = "The role definition ID of the role assignment."
  value       = try(rest_resource.role_assignment.output.properties.roleDefinitionId, null)
}

output "scope" {
  description = "The scope of the role assignment."
  value       = try(rest_resource.role_assignment.output.properties.scope, null)
}
