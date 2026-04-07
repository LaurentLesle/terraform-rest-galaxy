output "id" {
  description = "The full ARM resource ID of the user-assigned managed identity."
  value       = local.uai_path
}

output "api_version" {
  description = "The ARM API version used to manage this identity."
  value       = "2024-11-30"
}

output "name" {
  description = "The name of the identity (plan-time, echoes input)."
  value       = var.identity_name
}

output "location" {
  description = "The Azure region where the identity is deployed (plan-time, echoes input)."
  value       = var.location
}

output "principal_id" {
  description = "The object (principal) ID of the service principal associated with this identity."
  value       = try(rest_resource.user_assigned_identity.output.properties.principalId, null)
}

output "client_id" {
  description = "The client (application) ID associated with this identity."
  value       = try(rest_resource.user_assigned_identity.output.properties.clientId, null)
}

output "tenant_id" {
  description = "The tenant ID of the identity."
  value       = try(rest_resource.user_assigned_identity.output.properties.tenantId, null)
}
