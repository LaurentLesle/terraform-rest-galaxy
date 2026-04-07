output "azure_key_vault_keys" {
  description = "Map of key vault key outputs from the root module."
  value       = module.root.azure_values.azure_key_vault_keys
}
