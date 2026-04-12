output "id" {
  description = "The full ARM resource ID of the Azure Monitor Private Link Scope (plan-time, built from inputs)."
  value       = local.ampls_path
}

output "api_version" {
  description = "The ARM API version used to manage this resource."
  value       = local.api_version
}

output "name" {
  description = "The name of the Azure Monitor Private Link Scope (plan-time, echoes input)."
  value       = local._scope_name
}

output "location" {
  description = "The location of the Azure Monitor Private Link Scope (plan-time, echoes input)."
  value       = var.location
}

output "tags" {
  description = "The tags of the Azure Monitor Private Link Scope (plan-time, echoes input)."
  value       = var.tags
}

output "provisioning_state" {
  description = "The provisioning state of the Azure Monitor Private Link Scope (known after apply)."
  value       = try(rest_resource.monitor_private_link_scope.output.properties.provisioningState, null)
}

output "private_endpoint_connections" {
  description = "List of private endpoint connections attached to the scope (known after apply)."
  value       = try(rest_resource.monitor_private_link_scope.output.properties.privateEndpointConnections, null)
}
