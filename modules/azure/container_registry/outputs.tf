output "id" {
  description = "The full ARM resource ID of the container registry."
  value       = local.acr_path
}

output "api_version" {
  description = "The ARM API version used."
  value       = local.api_version
}

output "registry_name" {
  description = "The name of the container registry (echoes input)."
  value       = var.registry_name
}

output "location" {
  description = "The Azure region (echoes input)."
  value       = var.location
}

output "sku_name" {
  description = "The SKU name (echoes input)."
  value       = var.sku_name
}

output "login_server" {
  description = "The login server URL (e.g. myacr.azurecr.io)."
  value       = try(rest_resource.container_registry.output.properties.loginServer, null)
}

output "provisioning_state" {
  description = "The provisioning state."
  value       = try(rest_resource.container_registry.output.properties.provisioningState, null)
}

output "resource_group_name" {
  description = "The resource group name (echoes input)."
  value       = var.resource_group_name
}

output "subscription_id" {
  description = "The subscription ID (echoes input)."
  value       = var.subscription_id
}
