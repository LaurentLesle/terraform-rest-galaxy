output "id" {
  description = "The full ARM resource ID of the key vault."
  value       = local.kv_path
}

output "api_version" {
  description = "The ARM API version used to manage this key vault."
  value       = "2026-02-01"
}

output "name" {
  description = "The name of the key vault (plan-time, echoes input)."
  value       = var.vault_name
}

output "type" {
  description = "The resource type string returned by ARM."
  value       = try(rest_resource.key_vault.output.type, null)
}

output "location" {
  description = "The Azure region where the key vault is deployed (plan-time, echoes input)."
  value       = var.location
}

output "vault_uri" {
  description = "The URI of the vault for performing operations on keys and secrets (plan-time computed)."
  value       = "https://${var.vault_name}.vault.azure.net/"
}

output "provisioning_state" {
  description = "The provisioning state of the key vault."
  value       = try(rest_resource.key_vault.output.properties.provisioningState, null)
}

output "tenant_id" {
  description = "The tenant ID associated with this key vault."
  value       = try(rest_resource.key_vault.output.properties.tenantId, null)
}
