output "azure_data_collection_endpoints" {
  description = "Map of Data Collection Endpoint outputs from the root module."
  value       = module.root.azure_values.azure_data_collection_endpoints
}
