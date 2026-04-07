output "azure_resource_provider_features" {
  description = "Map of resource provider feature outputs from the root module."
  value       = module.root.azure_values.azure_resource_provider_features
}
