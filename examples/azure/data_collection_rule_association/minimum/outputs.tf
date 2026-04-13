output "azure_data_collection_rule_associations" {
  description = "Map of Data Collection Rule Association outputs from the root module."
  value       = module.root.azure_values.azure_data_collection_rule_associations
}
