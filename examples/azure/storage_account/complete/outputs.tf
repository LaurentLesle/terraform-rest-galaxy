output "azure_storage_accounts" {
  description = "Map of storage account outputs from the root module, keyed by instance name."
  value       = module.root.azure_values.azure_storage_accounts
}
