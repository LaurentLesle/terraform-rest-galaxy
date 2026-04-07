output "azure_key_vaults" {
  description = "Map of key vault outputs from the root module."
  value       = module.root.azure_values.azure_key_vaults
}
