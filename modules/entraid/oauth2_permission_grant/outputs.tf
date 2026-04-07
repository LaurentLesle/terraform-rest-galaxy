output "id" {
  description = "The unique identifier of the oauth2PermissionGrant."
  value       = rest_resource.oauth2_permission_grant.output.id
}

output "client_id" {
  description = "The object ID of the client service principal."
  value       = rest_resource.oauth2_permission_grant.output.clientId
}

output "resource_id" {
  description = "The object ID of the resource service principal."
  value       = rest_resource.oauth2_permission_grant.output.resourceId
}

output "scope" {
  description = "The granted delegated permission scopes."
  value       = rest_resource.oauth2_permission_grant.output.scope
}
