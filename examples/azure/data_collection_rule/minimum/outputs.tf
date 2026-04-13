output "azure_data_collection_rules" {
  description = "Map of Data Collection Rule outputs from the root module."
  value       = module.root.azure_values.azure_data_collection_rules
}
