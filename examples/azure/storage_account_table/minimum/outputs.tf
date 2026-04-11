output "azure_storage_account_tables" {
  description = "Map of table outputs."
  value       = module.root.azure_values.azure_storage_account_tables
}
