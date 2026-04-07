output "id" {
  description = "The full ARM resource ID of the key."
  value       = local.key_path
}

output "api_version" {
  description = "The ARM API version used to manage this key."
  value       = "2026-02-01"
}

output "name" {
  description = "The name of the key (plan-time, echoes input)."
  value       = var.key_name
}

output "type" {
  description = "The resource type string returned by ARM."
  value       = try(rest_operation.key_vault_key.output.type, null)
}

output "key_uri" {
  description = "The URI to retrieve the current version of the key."
  value       = try(rest_operation.key_vault_key.output.properties.keyUri, null)
}

output "key_uri_with_version" {
  description = "The URI to retrieve the specific version of the key."
  value       = try(rest_operation.key_vault_key.output.properties.keyUriWithVersion, null)
}
