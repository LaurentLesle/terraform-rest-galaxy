output "id" {
  description = "The full ARM resource ID of the extension."
  value       = local.ext_path
}

output "api_version" {
  description = "The ARM API version used to manage this extension."
  value       = local.api_version
}

output "extension_name" {
  description = "The name of the extension instance (echoes input)."
  value       = var.extension_name
}

output "cluster_name" {
  description = "The cluster name (echoes input)."
  value       = var.cluster_name
}

output "provisioning_state" {
  description = "The provisioning state of the extension."
  value       = try(rest_resource.extension.output.properties.provisioningState, null)
}

output "current_version" {
  description = "Currently installed version of the extension."
  value       = try(rest_resource.extension.output.properties.currentVersion, null)
}

output "extension_type" {
  description = "The extension type."
  value       = try(rest_resource.extension.output.properties.extensionType, null)
}

output "principal_id" {
  description = "The principal ID of the extension's managed identity."
  value       = try(rest_resource.extension.output.identity.principalId, null)
}

output "tenant_id" {
  description = "The tenant ID of the extension's managed identity."
  value       = try(rest_resource.extension.output.identity.tenantId, null)
}
