output "azure_storage_account_file_shares" {
  description = "Map of file share outputs."
  value       = module.root.azure_values.azure_storage_account_file_shares
}
