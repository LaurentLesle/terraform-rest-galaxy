output "id" {
  description = "The full ARM resource ID of the Log Analytics Workspace (plan-time, built from inputs)."
  value       = local.law_path
}

output "api_version" {
  description = "The ARM API version used to manage this resource."
  value       = local.api_version
}

output "name" {
  description = "The name of the Log Analytics Workspace (plan-time, echoes input)."
  value       = var.workspace_name
}

output "location" {
  description = "The location of the Log Analytics Workspace (plan-time, echoes input)."
  value       = var.location
}

output "tags" {
  description = "The tags of the Log Analytics Workspace (plan-time, echoes input)."
  value       = var.tags
}

output "provisioning_state" {
  description = "The provisioning state of the Log Analytics Workspace."
  value       = try(rest_resource.log_analytics_workspace.output.properties.provisioningState, null)
}

output "workspace_id" {
  description = "The unique identifier (customerId) of the Log Analytics Workspace (known after apply)."
  sensitive   = false
  value       = try(rest_resource.log_analytics_workspace.output.properties.customerId, null)
}

output "principal_id" {
  description = "The principal ID of the system-assigned managed identity (known after apply)."
  value       = try(rest_resource.log_analytics_workspace.output.identity.principalId, null)
}

output "tenant_id" {
  description = "The tenant ID of the system-assigned managed identity (known after apply)."
  value       = try(rest_resource.log_analytics_workspace.output.identity.tenantId, null)
}
